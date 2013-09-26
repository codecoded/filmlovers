class FacebookPresenter

  def self.recommendation_message(recommendation)
    
    if !recommendation.user.channels[:facebook]
      return "You have a new film recommendation! #{recommendation.user.username} liked #{recommendation.film.title}" 
    end

    if recommendation.friend.facebook_events.recent.count < 2
      "You have a new film recommendation! @[#{recommendation.user.passport_for(:facebook).uid}] liked #{recommendation.film.title}"
    else
      "You have several new film recommendations! Click here to discover new films to watch."
    end
  end
end