class RecommendationObserver < Mongoid::Observer

  def after_create(recommendation)
    create_facebook_notification recommendation
  end

  def create_facebook_notification(recommendation)
    return unless recommendation.friend.facebook and recommendation.friend.facebook_events.count <= 2
    message = FacebookPresenter.recommendation_message recommendation
    recommendation.friend.facebook.notifications Utilities.url_helpers.film_path(recommendation.recommendable)[1..-1], message, "recommendation"
    recommendation.friend.facebook_events.create content: message, event_type: :notification
  end

end