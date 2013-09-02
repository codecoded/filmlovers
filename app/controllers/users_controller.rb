class UsersController < ApplicationController
  before_filter :validate_current_user, :only => [:recommendations, :lists, :details, :settings]
  before_filter :validate_username, :except => [:index]
  #layout 'layouts/user'
  def index
  end

  def show
  end


  def validate_current_user
    redirect_to root_path if user.id != current_user.id
  end

  def validate_username
    redirect_to root_path unless user
  end

  def film_entries
    render :show
  end

  def recommendations
    render :show
  end

  def lists
    render :show
  end

  def friendships
    render :show
  end

  def details
    render :show
  end

  def settings
    render :show
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
    (params[:id] || :watched).to_sym
  end

  def order(default=:release_date)
    params[:order] || default
  end

  def users
    User.order_by(:username.asc).page(page_no).per 10
  end

  helper_method :viewing_own?, :user, :user_action, :order, :by, :users, :films
end