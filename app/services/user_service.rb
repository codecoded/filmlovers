class UserService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def films_queue
    user.films_queue
  end

  def list_films(action)
    user.actions_for(action).map &:film_id
  end

  def list_size(action)
    user.actions_for(action).count
  end

  def paged_list(list, order=:release_date, by = :desc, page_no = 1, page_size = 20)
    film_ids = list_films list
    results = Films.films_by(film_ids, order, by).slice(page_no * page_size, page_size)
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