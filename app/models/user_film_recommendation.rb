class UserFilmRecommendation

  attr_reader :user, :film

  def initialize(user, film)
    @user, @film = user, film
  end

  def recommend_to_friends(friends)
    friends.map {|friend| recommend_to_friend(friend)}.compact
  end

  def recommend_to_friend(friend)
    recommendations.create(friend: friend, recommendable: film, auto: false) if recommendable?(friend)
  end

  def recommendable?(friend)
    confirmed_friends.include?(friend.id.to_s) and !friend.film_user_actions.where(film_id: film.id).exists? 
  end

  def confirmed_friends
    @confirmed_friends ||= user.friendships.confirmed.map &:friend_id
  end

  def recommendations
    @recommendations ||= user.recommendations
  end
end