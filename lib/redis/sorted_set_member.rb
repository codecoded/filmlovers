class Redis::SortedSetMember
  
  attr_reader :key, :member

  def initialize(key, member)
    @key, @member = key, member
  end

  def add(score)
    $redis.zadd key, score, member 
  end

  def increment_by(value)
    $redis.zincrby key, value, member 
  end

  def rank(member)
    $redis.zrank key, member
  end

  def count
    $redis.zcard key
  end

  def range(start=0, stop=-1)
    $redis.zrange key, start, stop
  end

  def remove
    $redis.zrem key, member
  end

  def empty?
    count == 0
  end

  def score
    $redis.zscore key, member
  end

end