class ApplicationController < ActionController::Base
  protect_from_forgery

  
  private

  def logged_in?
    current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_service
    @user_service ||= UserService.new current_user
  end

  helper_method :current_user, :user_service, :username, :logged_in?
end
