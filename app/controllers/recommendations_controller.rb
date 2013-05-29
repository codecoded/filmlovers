class RecommendationsController < ApplicationController

  def index
  end

  def show
  end

  def create
  end

  def destroy
  end

  protected

  def user_recommendations
    @user_recommendations ||= current_user.recommendations.order_by(:created_at.desc)
  end

  def friends_recommmenations
    @friends_recommmenations ||= Recommendation.order_by(:created_at.desc).where(friend: current_user)
  end

  helper_method :user_recommendations, :friends_recommmenations
end
