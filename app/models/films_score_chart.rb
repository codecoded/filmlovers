class FilmsScoreChart 

  attr_reader :set

  def initialize(key)
    @set = Redis::SortedSetStore.new key
  end

  def films
    set.range_with_scores
  end

  def incr(film)
    set.incr film.id
  end

  def decr(film)
    set.decr film.id
  end

  def film(film)
    FilmCounter.new self, film.id
  end

end