class GenreRepository

  attr_reader :genre_id, :cache

  def initialize(genre_id)
    @genre_id = genre_id
    @cache = Redis::StringStore.new redis_key
  end

  def self.list
    @genres ||= Tmdb::Genre.list
  end

  def find
    is_cached? ? load : fetch
  end

  def is_cached?
    false
    # cache.exists?
  end

  def load
    doc = Genre.find id
    doc ? doc : fetch
  end

  def save_results!(results)
    return unless results
    results.each {|result| Film.create result}
  end

  def id
    cache.value
  end

  protected 

  def fetch
    genre = Genre.new(Tmdb::Genre.films(genre_id))
    # genre.upsert
    # cache.set genre.id
    save_results! genre.results
    genre
  end

  def redis_key
    "genre:#{genre_id}"
  end


end