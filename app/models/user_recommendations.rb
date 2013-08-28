class UserRecommendations

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def by_friends(order_by = {created_at: :desc})
    @by_friends ||= Recommendation.where(friend: user).order_by(order_by).visible
  end
  
  def unwatched
    @unwatched ||= by_friends.nin(recommendable: watched_films)
  end

  def watched
    @watched ||= by_friends.in(recommendable: watched_films)
  end

  def watched_films
    @watched_films ||= user.actions_for(:watched).map(&:film_id)
  end

  def recommendations
    @recommendations ||= user.recommendations
  end
end