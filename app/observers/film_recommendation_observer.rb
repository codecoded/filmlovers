class FilmRecommendationObserver < Mongoid::Observer

  def after_recommend(film_recommendation, transition)
    film = film_recommendation.film
    friend = film_recommendation.friend
    user = film_recommendation.user
    Log.debug "Film recommendation #{film.title} to #{friend.username} by #{user.username} created"

    friend.films.find_or_create(film).recommendations.create(friend_id: user.id, sent: false).receive
  end

  def after_receive(film_recommendation, transition)
    create_facebook_notification film_recommendation
  end

  def create_facebook_notification(recommendation)
    Log.debug "Trying to send FB notification for film recommendation #{recommendation.id}"
    friend = recommendation.friend
    return unless friend.facebook and recommendation.user.facebook and friend.facebook_events.recent.count <= 2
    message = FacebookPresenter.recommendation_message recommendation
    friend.facebook.notifications Utilities.url_helpers.film_path(recommendation.film)[1..-1], message, "recommendation"
    friend.facebook_events.create content: message, event_type: :notification
  end

end