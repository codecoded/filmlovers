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

  def list_size(list)
    list == :queued  ? films_queue.count : user.films[list].count 
  end

  def paged_list(list, order=:release_date, by = :desc, page_no = 1, page_size = 20)
    film_ids = list_films list
    results = FilmsRepository.films_by(film_ids, order, by).slice(page_no * page_size, page_size)
    # page_results = film_ids.slice(page_no * page_size, page_size)
    ResultsPage.new results || {}, list_size(list), page_size, page_no
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