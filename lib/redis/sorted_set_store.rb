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

  def rank_reversed(member)
    $redis.zrevrank key, member
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

  def range_with_scores_reversed(start=0, stop=-1)
    $redis.zrevrange key, start, stop, with_scores: 1
  end

  def range_by_score(min='-inf', max='+inf', with_scores=1)
    $redis.zrangebyscore key, min, max, with_scores: with_scores
  end

  def range_by_score_reversed(min='-inf', max='+inf', with_scores=1)
    $redis.zrevrangebyscore key, min, max, with_scores: with_scores
  end

  def remove(member)
    $redis.zrem key, member
  end

  def exists?(member)
    rank(member) != nil
  end

  def empty?
    count == 0
  end

  def score(member)
    $redis.zscore key, member
  end
end