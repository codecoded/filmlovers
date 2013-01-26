# redis_url = ENV['OPENREDIS_URL'] || 'redis://localhost:6379/'
# $redis = Redis.new(url:redis_url)

redis_url = ENV['REDISTOGO_URL'] || 'redis://localhost:6379/'
uri = URI.parse(redis_url)
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

$redis.select(ENV['REDISTOGO_URL']  ? 0 : 14)