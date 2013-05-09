class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def logged_in?
    user_signed_in?
  end
  
  def user_service
    @user_service ||= UserService.new current_user
  end

  def current_url(new_params={})
    url_for params.merge(new_params)
  end

  def get_layout
    request.xhr? ? {layout:nil} : {}
  end

  def render_template(view=nil)
    if view
      render view, get_layout
    else
      render get_layout
    end
  end

  helper_method :current_user, :user_service, :username, :logged_in?, :current_url
end
