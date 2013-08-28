class UserRecommendationsController < ApplicationController

  def index
  end

  def sent
    @sent ||= user.recommendations
  end

  def received
    @received ||= Recommendation.where(friend: user)
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
    recommendation.unrecommend!
    render nothing: true
  end

  protected
  def user
    @user ||= User.find_by(username:params[:user_id])
  end

  helper_method :sent, :received
end
