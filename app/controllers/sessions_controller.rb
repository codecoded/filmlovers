class SessionsController < ApplicationController

  def create
    passport = Passport.from_omniauth(env["omniauth.auth"])
    user = current_user ? current_user : User.from_omniauth(env["omniauth.auth"])
    user.upsert_passport passport
    env['warden'].set_user(user)
    redirect_to root_url
  end

  def facebook
    create
  end


  def destroy
    reset_session
    redirect_to root_url
  end

  def currentuser
    render json:{name:''} and return unless current_user
    @user = current_user
  end
end
