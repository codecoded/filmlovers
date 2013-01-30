class FilmPresenter
  extend Forwardable

  attr_reader :user, :film, :thumbnail_size

  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?

  def initialize(user, film, thumbnail_size='w185')
    @user, @film, @thumbnail_size = user, film, thumbnail_size
  end

  def self.from_films(user, films)
    films.map {|film| FilmPresenter.new user, film }
  end
  
  def actioned?(action)
    user.films[action].is_member? film.id
  end

  def thumbnail(size='w185')

   has_poster? ? film.poster(size ? size : thumbnail_size) : 'http://placehold.it/185x237&text=no%20poster%20found'
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

  def year
    year ||= Date.parse(film.release_date).year
  end

  def similar_films
    return unless film.similar_movies
    film.similar_movies['results'].map {|f| FilmPresenter.new user, Film.new(f), 'w92'}
  end
end