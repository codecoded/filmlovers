class RecommendationsController < ApplicationController

  def index
  end

  def show
  end

  def create
  end

  def destroy
    recommendation.unrecommend!
    render nothing: true
  end

  protected

  def recommendation
    @recommendation ||= Recommendation.find params[:id]
  end

  def user_recommendations
    @user_recommendations ||= current_user.recommendations.order_by(:created_at.desc).visible
  end

  def friends_recommmenations
    @friends_recommmenations ||= current_user.recommended.unwatched
  end

  helper_method :user_recommendations, :friends_recommmenations
end
