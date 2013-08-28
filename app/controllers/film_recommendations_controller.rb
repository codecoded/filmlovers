class FilmRecommendationsController < ApplicationController

  def index
  end

  def show
  end

  def create

  end

  def update
    UserFilmRecommendation.new(current_user, film).recommend_to_friends(friends)
  end

  def destroy
    recommendation.unrecommend!
    render nothing: true
  end

  protected

  def friends
    return current_user.friendships.confirmed.map &:friend
    @friend ||= User.find(params[:friend_ids])
  end

  def film
    @film ||= Film.find params[:id]
  end

  # def recommendation
  #   @recommendation ||= Recommendation.find params[:id]
  # end

  # def user_recommendations
  #   @user_recommendations ||= current_user.recommendations.order_by(:created_at.desc).visible
  # end

  # def friends_recommmenations
  #   @friends_recommmenations ||= current_user.recommended.unwatched
  # end

  helper_method :user_recommendations, :friends_recommmenations
end
