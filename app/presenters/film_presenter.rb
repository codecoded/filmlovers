class FilmPresenter
  extend Forwardable

  attr_reader :user, :film, :thumbnail_size

  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?, :has_trailer?, :overview

  def initialize(user, film, thumbnail_size='w185')
    @user, @film, @thumbnail_size = user, film, thumbnail_size
  end

  # def self.from_films(user, films)
  #   films.map {|film| FilmPresenter.new user, film } if !films.empty?
  # end
  
  def self.from_films(user, film_ids)
    Film.find(film_ids).map {|film| FilmPresenter.new user, film } if !film_ids.empty?
  end

  def actioned?(action)
    action == :queued ? user.films_queue.exists?(film.id) : user.films[action].is_member?(film.id)
  end

  def stats(action)
    film.users[action].count
  end

  def thumbnail(size='w185')
   has_poster? ? film.poster(size ? size : thumbnail_size) : "http://placehold.it/#{size.slice(1..-1)}&text=no%20poster%20found"
  end

  def backdrop(size='original')
    film.backdrop(size)
  end

  def release_date
    film.release_date ? "#{Date.parse(film.release_date).year}" : ''
  end

  def director
    @director ||= film.credits.crew.find {|member| member['job']=='Director'}
    @director ? @director['name'] : ''
  end

  def trailer
    "http://www.youtube.com/embed/#{film.trailer}" if film.has_trailer?
  end

  def backdrops
    film.images_library.backdrops
  end

  def year
    @year ||= (Date.parse(film.release_date).year if film.release_date)
  end

  def similar_films?
    film.similar_movies
  end

  def similar_films
    return unless similar_films?
    film.similar_movies['results'].map {|f| FilmPresenter.new user, Film.new(f), 'w92'}
  end
end