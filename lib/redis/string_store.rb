class Redis::StringStore

  attr_reader  :key

  def initialize(key)
    @key = key
  end

  def value
    $redis.get key
  end

  def delete!
    $redis.del key
  end

  def increment
    $redis.incr key
  end

  def increment_by(value)
    $redis.incrby key, value
  end

  def set(value)
    $redis.set key, value
  end

  def exists?
    value
  end
end