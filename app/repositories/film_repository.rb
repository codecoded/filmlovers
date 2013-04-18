class FilmRepository

  attr_reader :film_id, :cache

  def initialize(film_id)
    @film_id = film_id
    @cache = Redis::StringStore.new redis_key
  end

  def self.find(film_id)
    new(film_id).find
  end
  
  def find
    is_cached? ? load : fetch
  end

  def is_cached?
    film and film.fetched != nil
  end

  def load
    film || fetch
  end

  def film
    @film ||= film_id.numeric? ? Film.find(film_id.to_i) : Film.find_by(_title_id: film_id)
  end

  def redis_key
    "film:#{film_id}"
  end

  protected 

  def fetch
    id = film ? film._id : film_id
    _film = Film.new Tmdb::Movie.find(id)
    _film.fetched = Time.now.utc
    _film.upsert
    _film
    # cache.set film_id
    # Film.find(film_id)
  end

end