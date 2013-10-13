class FilmRecommendationObserver < Mongoid::Observer

  def after_recommend(film_recommendation, transition)
    film = film_recommendation.film
    friend = film_recommendation.friend
    user = film_recommendation.user
    comment = film_recommendation.comment
    Log.debug "Film recommendation #{film.title} to #{friend.username} by #{user.username} created"

    friend.films.find_or_create(film).recommendations.create(friend_id: user.id, sent: false, comment: comment).receive
  end

  def after_receive(film_recommendation, transition)
    push_desktop_notification film_recommendation
    push_facebook_notification film_recommendation
    push_ios_notification film_recommendation
  end

  def push_facebook_notification(recommendation)
    Log.debug "Trying to send FB notification for film recommendation #{recommendation.id}"
    friend = recommendation.user
    return unless friend.channels[:facebook] and recommendation.user.channels[:facebook] and friend.facebook_events.recent.count <= 2
    message = FacebookPresenter.recommendation_message recommendation
    friend.channels[:facebook].notifications(Utilities.url_helpers.film_path(recommendation.film)[1..-1], message, "recommendation")
    friend.facebook_events.create content: message, event_type: :notification
  end

  def push_ios_notification(film_recommendation)
    Log.debug "Trying to send iOS notification for film recommendation #{film_recommendation.id}"
    notice = "#{film_recommendation.friend.username} recommended #{film_recommendation.film.title}. #{film_recommendation.comment}"
    Log.debug notice
    friend = film_recommendation.user
    return unless friend.mobile_devices.registered? :iPhone
    friend.notifier.push_to_mobile notice
    Log.debug 'iOS film recommendation recorded - ensure daemon is running'
  end

  def push_desktop_notification(film_recommendation)
    notice = "#{film_recommendation.friend.username} recommended #{film_recommendation.film.title}. #{film_recommendation.comment}"
    Log.debug notice
    film_recommendation.user.notifier.toast notice
  end

end