class UserService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def add(film, list)
    return unless user.films[list].add film.id
    film.users[list].add user.id
    Films[list].incr film
  end

  def remove(film, list)
    return unless user.films[list].remove film.id
    film.users[list].remove user.id
    Films[list].decr film
  end

  def list_films(list)
    user.films[list].members 
  end

  def films_in_list(list)
    list_films(list).map {|film_id| Film.fetch(film_id.to_i)}
  end
end