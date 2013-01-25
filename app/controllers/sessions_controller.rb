class SessionsController < ApplicationController

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  def currentuser
    render json:{name:''} and return unless current_user
    respond_to do |format|
      format.json { render json:{
          name: current_user.name,
        }}
    end
  end
end
