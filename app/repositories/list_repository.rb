class ListRepository

  attr_reader :id, :cache

  def initialize(id)
    @id = id
    @cache = Redis::StringStore.new redis_key
  end

  def find
    is_cached? ? load : fetch
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = List.find id
    doc ? doc : fetch
  end

  def redis_key
    "list:#{id}"
  end

  protected 

  def fetch
    list = List.new Tmdb::List.find(id)
    cache.set list.id
    lst
  end

end