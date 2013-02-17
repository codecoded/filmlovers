class Redis::SetStore
  attr_reader :key

  def initialize(key)
    @key = key
  end

  def add(member)
    $redis.sadd key, member 
  end

  def members
    $redis.smembers key
  end

  def is_member?(member)
    $redis.sismember key, member
  end

  def remove(member)
    $redis.srem key , member
  end

  def empty?
    count == 0
  end

  def count
    $redis.scard key
  end

  def delete_set!
    $redis.del key
  end

end