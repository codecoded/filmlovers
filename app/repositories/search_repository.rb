class SearchRepository

  attr_reader :query, :search_type, :options, :cache

  def initialize(query, search_type=:movie, options={})
    @query, @search_type, @options = query, search_type, options
    @cache = Redis::HashField.new redis_key, redis_field
  end

  def find
    Search.new(is_cached? ? load : fetch)
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = Searches.find_by_id(id)
    doc ? doc : fetch
  end

  def save!(doc)
    cache.set Searches.save(doc)
    save_results! doc['results']
    doc
  end

  def save_results!(results)
    return unless search_type == :movie and results
    results.each do |result|
      Films.save!(result) unless Films.exists? result['id']
    end
  end

  def id
    cache.value
  end

  protected 

  def fetch
    save! Tmdb::Search.new(query, search_type).find(options)
  end

  def redis_key
    "search:#{search_type}"
  end

  def redis_field
    (options.flatten << search_type << query).join('|')
  end

end