class PersonRepository

  attr_reader :id, :cache

  def initialize(id)
    @id = id
    @cache = Redis::StringStore.new redis_key
  end

  def self.find(id)
    new(id).find
  end
  
  def find
    is_cached? ? load : fetch
  end

  def is_cached?
    cache.exists?
  end

  def load
    doc = Person.find id
    doc ? doc : fetch
  end

  def redis_key
    "person:#{id}"
  end

  protected 

  def fetch
    person = Person.new Tmdb::Person.find(id)
    person.upsert
    cache.set person.id
    person
  end

end