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
    cache.exists?
  end

  def load
    Film.find(film_id) || fetch
  end

  def redis_key
    "film:#{film_id}"
  end

  protected 

  def fetch
    film = Film.new Tmdb::Movie.find(film_id)
    film.upsert
    cache.set film.id
    Film.find(film_id)
  end

end