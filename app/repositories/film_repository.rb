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
    Film.new(is_cached? ? load : save!(fetch))
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = Films.find_by_id film_id
    doc ? doc : fetch
  end

  def save!(doc)
    cache.set Films.save! doc
    doc
  end

  def redis_key
    "film:#{film_id}"
  end

  protected 

  def fetch
    Tmdb::Movie.find(film_id)
  end

end