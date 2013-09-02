class UserComparison

  attr_reader :user_a, :user_b

  def initialize(user_a, user_b)
    @user_a, @user_b = user_a, user_b
  end

  def overall
    actions = [:watched, :loved]
    total = actions.inject(0){ |total, action| total + percentage_for_films(action)}
    total.to_f / actions.count
  end

  def percentage_for_films(action)
    user_a_films = films_set user_a, action
    user_b_films = films_set user_b, action

    total = user_a_films.count + user_b_films.count

    ((user_a_films & user_b_films).count.to_f * 2)/ total.to_f * 100
  end

  def matches_for(action)
    user_a_films = films_set user_a, action
    user_b_films = films_set user_b, action

    user_a_films & user_b_films
  end

  def films_set(user, action)
    Rails.cache.fetch "#{user.username}_#{action}_count", expires_in: 10.minutes do
      user.films[action].map {|fe| fe.film['_id']}.to_set
    end
  end

end