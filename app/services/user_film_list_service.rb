class UserFilmListService
  attr_reader :film_list, :user

  def initialize(film_list)
    @film_list, @user = film_list, film_list.user
  end

  def set_films(film_ids)
    film_list.queue.set.delete
    film_ids.each {|film_id| film_list.queue.insert(film_id)}
  end

  def move_films_from_queue(film_ids)
    film_ids.each do |film_id|
      move_film_from_queue film_id
    end
  end

  def copy_films_from_queue(film_ids)
    film_ids.each do |film_id|
      copy_film_from_queue film_id
    end
  end

  def move_film_from_queue(film_id)
    film_list.queue.insert(film_id) if user.films_queue.remove film_id
  end

  def copy_film_from_queue(film_id)
    film_list.queue.insert(film_id) if user.films_queue.exists? film_id
  end

  def delete_list
    film_list.queue.set.delete
    film_list.delete
  end

  def update!(attributes)
    film_list.update_attributes! attributes
  end

end