class UsersController < ApplicationController
  before_filter :validate_username

  #layout 'layouts/user'

  def validate_current_user
    @is_current_user = user.id == current_user.id
  end

  def validate_username
    redirect_to root_path unless user
  end

  def show
    results_page =  UserService.new(user).paged_list(user_action, order, by, params[:page].to_i, 70)
    @films_page = FilmsPagePresenter.new user, results_page, user_action
  end

  def user
    if BSON::ObjectId.legal? user_id
      @user ||= User.find(user_id)
    else
      @user ||= User.find_by(username: user_id)
    end
  end

  def user_id
    params[:user_id]
  end
  
  def viewing_own?
    user.id == (logged_in? and current_user.id)
  end

  def user_action
    (params[:user_action] || :watched).to_sym
  end

  def order
    params[:order] || :release_date
  end

  def by
    params[:by] || :desc
  end

  helper_method :viewing_own?, :user, :user_action, :order, :by
end