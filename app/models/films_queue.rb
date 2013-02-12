class FilmsQueue 

  attr_reader :set

  def initialize(key)
    @set = Redis::SortedSetStore.new key
  end

  def id
    set.key
  end

  def films
    set.range
  end

  def count
    set.count
  end
  
  def insert(film_id)
    set.add Time.now.to_i, film_id
  end

  def remove(film_id)
    set.remove film_id
  end

  def exists?(film_id)
    set.exists? film_id
  end
end