class AppController < ApplicationController
  
  before_filter :check_username, only: :index
  
  def check_username
    redirect_to edit_user_registration_path if current_user and !current_user.username?
  end

  def index
    Log.debug "User logged in from #{user_location.city}, #{user_location.data['country_name']} (#{user_location.data['country_code']})}" if user_location?
    @user = User.new
  end

  def preview
  end

  def login
    render partial: 'login' 
  end

end
