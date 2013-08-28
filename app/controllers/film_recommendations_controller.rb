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
    @friend ||= User.find(params[:friend_id])
  end

  def film
    @film ||= Film.find params[:id]
  end


  helper_method :user_recommendations, :friends_recommmenations
end
