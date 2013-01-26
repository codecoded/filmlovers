class SearchRepository

  attr_reader :query, :search_type, :options, :cache

  def initialize(query, search_type=:movie, options={})
    @query, @search_type, @options = query, search_type, options
    @cache = Redis::HashField.new redis_key, redis_field
  end

  def find
    is_cached? ? load : fetch
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = Search.find_by id:id
    doc ? doc : fetch
  end

  def save_results!(results)
    return unless search_type == :movie and results
    results.each {|result| Film.create! result}
  end

  def id
    cache.value
  end

  protected 

  def fetch
    search = Search.create!(Tmdb::Search.new(query, search_type).find(options))
    cache.set search.id
    save_results! search.results
    search
  end

  def redis_key
    "search:#{search_type}"
  end

  def redis_field
    (options.flatten << search_type << query).join('|')
  end

end