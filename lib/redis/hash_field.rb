class Redis::HashField

  attr_reader  :field, :key

  def initialize(key, field)
    @key = key
    @field = field
  end

  def value
    $redis.hget key, field
  end

  def increment_by(value)
    $redis.hincrby key, field, value
  end

  def hash_increment_by_float(value)
    $redis.hincrbyfloat key, field, value
  end

  def set(value)
    $redis.hset key, field, value
  end

  def exists?
    $redis.hexists key, field
  end
end