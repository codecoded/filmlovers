class ApplicationController < ActionController::Base
  include PageOptions
  protect_from_forgery

  before_filter :facebook_authenticate, unless: -> {params[:signed_request].nil?}

  private

  def facebook_authenticate
    user = FacebookAuth.authenticate(params[:signed_request])
    !user.new_record? ? env['warden'].set_user(user) : redirect_to_auth
  end

  def redirect_to_auth
    render('facebook/oauth_redirect', layout:nil)
  end 

  def logged_in?
    user_signed_in?
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

  def user_location
    return session[:user_location] if session[:user_location]
    location = request.location
    session[:user_location] = location
    Log.info "User logged in from #{location.city}, #{location.data['country_name']} (#{location.data['country_code']})}" if user_location?
    location    
  rescue => msg
    Log.error "Unable to find users location. Msg: #{msg}"
  end

  def user_location?
    !user_location.nil? and user_location.latitude != 0
  end

  helper_method :current_user, :username, :logged_in?, :current_url
end
