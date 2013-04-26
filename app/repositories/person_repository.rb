class PersonRepository

  attr_reader :id, :cache

  def initialize(id)
    @id = id
    # @cache = Redis::StringStore.new redis_key
  end

  def self.find(id)
    new(id).find
  end
  
  def find
    is_cached? ? load : fetch
  end

  def is_cached?
    person and person.fetched != nil
  end

  def load
    person || fetch
  end

  def person
    @person ||= id.numeric? ? Person.find(id.to_i) : Person.find_by(_title_id: id)
  end

  def redis_key
    "person:#{id}"
  end

  protected 

  def fetch
    _id = person ? person._id : id
    _person = Person.new Tmdb::Person.find(_id)
    _person.fetched = Time.now.utc
    _person.upsert
    _person
  end

end