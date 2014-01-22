class FacebookPresenter

  def self.recommendation_message(recommendation)
    sender = recommendation.user
    receiver = recommendation.friend

    if !sender.channels[:facebook]
      return "#{receiver.username} recommends #{recommendation.film.title}. #{recommendation.comment}" 
    end

    if receiver.facebook_events.recent.count < 2
      "@[#{receiver.passport_for(:facebook).uid}] recommends #{recommendation.film.title}. #{recommendation.comment}"
    else
      "You have several new film recommendations! Click here to discover new films to watch."
    end
  end

end