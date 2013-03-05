class UserFilmListService
  attr_reader :film_list, :user

  def initialize(film_list)
    @film_list, @user = film_list, film_list.user
  end

  def move_films_from_queue(film_ids)
    film_ids.each do |film_id|
      film_list.append_film(film_id) if user.films_queue.remove film_id
    end
  end

  def copy_films_from_queue(film_ids)
    film_ids.each do |film_id|
      film_list.append_film(film_id) if user.films_queue.exists? film_id
    end
  end

  def delete_list
    film_list.delete
  end

  def update!(attributes)
    film_list.film_list_items.delete_all
    film_list.update_attributes! attributes
  end

  def film_list_items
    film_list.film_list_items
  end

end