class ApplicationController < ActionController::Base
  include PageOptions
  protect_from_forgery

  before_filter :facebook_authenticate, unless: -> {params[:signed_request].nil?}

  private

  def facebook_authenticate
    user = FacebookAuth.authenticate(params[:signed_request])
    if user.new_record?
      redirect_to_auth 
    else
      env['warden'].set_user(user)
    end
  end

  def redirect_to_auth
    params.reject! {|k,v| k.to_sym==:signed_request}
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
    Rails.cache.fetch request.remote_ip, expires_in: 24.hours do 
      loc = UserLocation.new(request.location)
      Log.info loc.to_s
      loc
    end        
  rescue => msg
    Log.error "Unable to find users location. Msg: #{msg}"
  end

  helper_method :current_user, :username, :logged_in?, :current_url, :user_location
end
