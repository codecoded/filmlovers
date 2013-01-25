class ListRepository

  attr_reader :id, :cache

  def initialize(id)
    @id = id
    @cache = Redis::StringStore.new redis_key
  end

  def find
    List.new(is_cached? ? load : fetch)
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = Lists.find_by_id id
    doc ? doc : fetch
  end

  def save!(doc)
    doc['_id'] = id
    cache.set Lists.save doc
    doc
  end

  def redis_key
    "list:#{id}"
  end

  protected 

  def fetch
    save! Tmdb::List.find(id)
  end

end