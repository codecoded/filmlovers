class FilmRecommendationObserver < ActiveRecord::Observer
  observe :film_recommendation

  def after_create(film_recommendation)
    push_desktop_notification film_recommendation
    push_facebook_notification film_recommendation
    push_ios_notification film_recommendation
  end

  def push_facebook_notification(recommendation)
    Log.debug "Trying to send FB notification for film recommendation #{recommendation.id}"
    receiver = recommendation.user
    sender = recommendation.friend

    return unless receiver.channels[:facebook] and receiver.facebook_events.recent.count <= 2
    message = FacebookPresenter.recommendation_message(recommendation).html_safe
    receiver.channels[:facebook].notifications(Utilities.url_helpers.film_path(recommendation.film)[1..-1], message, "recommendation")
    receiver.facebook_events.create content: message, event_type: :notification
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