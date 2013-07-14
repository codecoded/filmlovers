class UsersController < ApplicationController
  before_filter :validate_username,:except => :create

  #layout 'layouts/user'
  def index
    
  end



  def validate_current_user
    @is_current_user = user.id == current_user.id
  end

  def validate_username
    redirect_to root_path unless user
  end

  def show
    results_page =  UserService.new(user).paged_list(user_action, order, by, page_no, 70)
    @films_page = FilmsPagePresenter.new current_user, results_page, user_action
  end

  def user
    return current_user unless user_id
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
    (params[:id] || :watched).to_sym
  end

  def order(default=:release_date)
    params[:order] || default
  end


  def users
    User.order_by(:username.asc).page(page_no).per 10
  end


  helper_method :viewing_own?, :user, :user_action, :order, :by, :users
end