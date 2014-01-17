class FilmRecommendationService

  attr_reader :user, :film

  def initialize(user, film)
    @user, @film = user, film
  end

  def film_recommendations
    user.film_recommendations.for_film(film)
  end

  def recommend_to(friendships, comment=nil)
    @recommendations = film_recommendations.to_a

    friendships.map do |friendship| 
      create friendship, comment
    end
  end

  def create(friendship, comment)
    return unless recommendable_to?(friendship)
    film_recommendations.create(friend_id: friendship.friend_id, comment: CGI.unescape(comment), sent:true) 
  end

  def recommendable_to?(friendship)
    friendship.confirmed? and !already_recommended_to?(friendship)
  end

  def already_recommended_to?(friendship)
    @recommendations.any? {|fr| fr.friend_id == friendship.friend_id}
  end

  def available_friends
    recommended_already_to = film_recommendations.pluck :friend_id
    confirmed = user.friendships.confirmed
    recommended_already_to.empty? ? confirmed : confirmed.where('friend_id not in (?)', recommended_already_to)
  end

end