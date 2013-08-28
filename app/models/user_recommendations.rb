class UserRecommendations

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def recommend_film_to_friends(film, friends)
    friends.map {|friend| recommend_film_to_friend(film, friend)}
  end

  def recommend_film_to_friend(film, friend)
    recommendations.create(friend: friend, recommendable: film, auto: false) unless friend_actioned_film?(film, friend)
  end

  def friend_actioned_film?(film, friend)
    friend.film_user_actions.where(film_id: film.id).exists?
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