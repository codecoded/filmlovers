class AppController < ApplicationController
  
  before_filter :check_username, only: :index
  
  def check_username
    redirect_to edit_user_registration_path if current_user and !current_user.username?
  end

  def index
    render_template
  end

  def preview
  end

  def login
    render partial: 'login' 
  end
end
