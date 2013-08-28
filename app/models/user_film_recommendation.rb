class UserFilmRecommendation

  attr_reader :user, :film

  def initialize(user, film)
    @user, @film = user, film
  end

  def recommend_to_friends(friends)
    friends.map {|friend| recommend_to_friend(friend)}.compact
  end

  def recommend_to_friend(friend)
    recommendations.create(friend: friend, recommendable: film, auto: false) if recommendable_to?(friend)
  end

  def recommendable_to?(friend)
    confirmed_friends_with?(friend) and 
    film_not_yet_recommended_to?(friend) and
    film_not_actioned_by(friend)
  end

  def confirmed_friends_with?(friend)
    confirmed_friends.include?(friend.id.to_s)
  end

  def film_not_yet_recommended_to?(friend)
    !Recommendation.recommended? user, friend, film
  end

  def film_not_actioned_by?(friend)
    !friend.film_user_actions.where(film_id: film.id).exists? 
  end

  def confirmed_friends
    @confirmed_friends ||= user.friendships.confirmed.map &:friend_id
  end

  def recommendations
    @recommendations ||= user.recommendations
  end
end