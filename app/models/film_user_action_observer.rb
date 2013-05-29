class FilmUserActionObserver < Mongoid::Observer

  def after_create(film_user_action)
    return unless film_user_action.action == :loved
    Log.debug "Created film_user_action: #{film_user_action}"
    comparer = ComparisonService.new film_user_action.user
    Thread.new do
      comparer.friends_sorted_by_rating(20).each do |rated_friend|
        film_user_action.user.recommendations.create friend: rated_friend[:friend], recommendable: film_user_action.film, auto: true
      end
    end
  end

end