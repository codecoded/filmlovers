class UserService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def films_queue
    user.films_queue
  end

  def add(film, list)
    return unless user.films[list].add film.id
    film.users[list].add user.id
    Films[list].incr film
    user.films[list].count
  end

  def remove(film, list)
    return unless user.films[list].remove film.id
    film.users[list].remove user.id
    Films[list].decr film
    user.films[list].count
  end

  def list_films(list)
    list == :queued  ? films_queue.films : user.films[list].members 
  end

  def films_in_list(list)
    list_films(list).map {|film_id| Film.find(film_id.to_i)}
  end

  def films_list(id)
    user.films_lists.find id
  end

  def queue(film)
    films_queue.insert film.id
    films_queue.count
  end

  def dequeue(film)
    films_queue.remove film.id
    films_queue.count
  end
end