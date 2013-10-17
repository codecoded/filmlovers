class FacebookPresenter

  def self.recommendation_message(recommendation)
    receiver = recommendation.user
    sender = recommendation.friend

    if !sender.channels[:facebook]
      return "#{recommendation.sender.username} recommends #{recommendation.film.title}. #{recommendation.comment}" 
    end

    if recommendation.receiver.facebook_events.recent.count < 2
      "@[#{recommendation.sender.passport_for(:facebook).uid}] recommends #{recommendation.film.title}. #{recommendation.comment}"
    else
      "You have several new film recommendations! Click here to discover new films to watch."
    end
  end

end