class UserFilmListService
  attr_reader :film_list, :user

  def initialize(film_list)
    @film_list, @user = film_list, film_list.user
  end

  def add_films_from_queue(film_ids)
    film_ids.each do |film_id|
      move_film_from_queue film_id
    end
  end

  def move_film_from_queue(film_id)
    film_list.queue.insert(film_id) if user.films_queue.remove film_id
  end

  def delete_list!
    film_list.delete
  end

  def update!(new_film_list)
    film_list.name = new_film_list.name
    film_list.description = new_film_list.description
    film_list.save!
  end

  def change_description(description)
  end
end