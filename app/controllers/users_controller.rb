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
    @user ||= User.fetch(user_id)
  end

  def user_id
    params[:user_id] || current_user.id
  end
  
  def viewing_own?
    user.id == (logged_in? and current_user.id)
  end

  def user_action
    (params[:id] || :watched).to_sym
  end

  def order(default=:recent_action)
    params[:order] || default
  end

  def users
    options = paging_options sort_by: :username, page_size: 10
    all_users = logged_in? ? User.where('id != ?', current_user.id) : User
    @results = ActiveUserQuery.new(all_users, options).results
  end

  helper_method :viewing_own?, :user, :user_action, :users, :films
end