class FacebookPresenter

  def self.recommendation_message(recommendation)
    
    if !recommendation.user.channels[:facebook]
      return "#{recommendation.user.username} recommends #{recommendation.film.title}. #{recommendation.comment}" 
    end

    if recommendation.friend.facebook_events.recent.count < 2
      "@[#{recommendation.user.passport_for(:facebook).uid}] recommends #{recommendation.film.title}. #{recommendation.comment}"
    else
      "You have several new film recommendations! Click here to discover new films to watch."
    end
  end

end