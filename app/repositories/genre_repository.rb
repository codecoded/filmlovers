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
    Genre.new(is_cached? ? load : fetch)
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = Genres.find_by_id id
    doc ? doc : fetch
  end

  def save!(doc)
    cache.set Genres.save doc
    save_results! doc['results']
    doc
  end

  def save_results!(results)
    return unless results
    results.each do |result|
      Films.save!(result) unless Films.exists? result['id']
    end
  end

  def id
    cache.value
  end

  protected 

  def fetch
    save! Tmdb::Genre.films(genre_id)
  end

  def redis_key
    "genre:#{genre_id}"
  end


end