class Redis::SortedSetStore

  attr_reader :key

  def initialize(key)
    @key = key
  end

  def length
    $redis.zcard key
  end

  def add(score, member)
    $redis.zadd key, score, member 
  end

  def incr(member)
    increment_by 1, member
  end

  def increment_by(value, member)
    $redis.zincrby key, value, member 
  end

  def decr(member)
    increment_by -1, member
  end

  def rank(member)
    $redis.zrank key, member
  end

  def exists?(member)
    rank(member) != nil
  end

  def count
    $redis.zcard key
  end

  def range(start=0, stop=-1)
    $redis.zrange key, start, stop
  end

  def range_with_scores(start=0, stop=-1)
    $redis.zrange key, start, stop, with_scores: 1
  end

  def remove(member)
    $redis.zrem key, member
  end

  def empty?
    count == 0
  end

  def score(member)
    $redis.zscore key, member
  end
end