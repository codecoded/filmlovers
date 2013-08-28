class UserFilmRecommendation

  attr_reader :user, :film

  def initialize(user, film)
    @user, @film = user, film
  end

  def recommend_to_friends(friends)
    friends.map {|friend| recommend_to_friend(friend)}
  end

  def recommend_to_friend(friend)
    recommendations.create(friend: friend, recommendable: film, auto: false) unless friend_actioned_film?(friend)
  end

  def friend_actioned_film?(friend)
    friend.film_user_actions.where(film_id: film.id).exists?
  end

  def recommendations
    @recommendations ||= user.recommendations
  end
end