class UserController < ApplicationController
  before_filter :validate_username


  def validate_current_user
    @is_current_user = user.id == current_user.id
  end

  def validate_username
    redirect_to root_path unless user
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
    user.id == current_user.id
  end

  helper_method :viewing_own?
end