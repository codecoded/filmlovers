class FilmRecommendationsController < ApplicationController

  def index
    current_user.films.recommended
  end

  def create
    return head 400 if friend_ids.nil?
    @recommendations = film_recommendation_service.recommend_to selected_friends, comment
  end

  def new
  end

  protected

  def film_recommendation_service
    FilmRecommendationService.new(current_user, film)
  end

  def selected_friends
    friendships.where(friend_id: friend_ids)
  end

  def comment
    params[:film_recommendation][:comment] if params[:film_recommendation]
  end

  def film_recommendation
    params[:id] ? FilmRecommendation.find(params[:id]) : film.recommendations.new(user_id: current_user.id)
  end

  def friendships
    @friendships ||= film_recommendation_service.available_friends
  end

  def film_id
    params[:film_id]
  end

  def friend_ids
    params[:friend_id]
  end

  def film
    @film ||= Film.find film_id
  end

  helper_method :friendships, :film, :film_recommendation

end
