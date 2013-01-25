class FilmPresenter
  extend Forwardable

  attr_reader :user, :film

  def_delegators :film, :title, :has_poster?, :id

  def initialize(user, film)
    @user, @film = user, film
  end

  def self.from_films(user, films)
    films.map {|film| FilmPresenter.new user, film }
  end
  
  def actioned?(action)
    user.films[action].is_member? film.id
  end

  def thumbnail
   has_poster? ? film.poster('w185') : 'http://placehold.it/185x237&text=no%20poster%20found'
  end

  def release_date
    film.release_date ? "#{Date.parse(film.release_date).year}" : ''
  end


end