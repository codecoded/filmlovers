class FilmRepository

  attr_reader :film_id

  def initialize(film_id)
    @film_id = film_id
  end

  def self.find(film_id)
    new(film_id).find
  end
  
  def find
    film ? film : fetch
  end

  def film
    @film ||= film_id.numeric? ? Film.find(film_id.to_i) : Film.find_by(_title_id: film_id)
  end


  protected 

  def fetch
    id = film ? film._id : film_id
    _film = Film.new Tmdb::Movie.find(id)
    return nil if _film.not_allowed?
    _film.fetched = Time.now.utc
    _film.upsert
    _film
  end

end