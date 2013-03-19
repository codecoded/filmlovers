class FilmsScoreChart 

  attr_reader :set

  def initialize(key)
    @set = Redis::SortedSetStore.new key
  end

  def films(count=-1)
    set.range_with_scores_reversed 0, count
  end

  def incr(film)
    set.incr film.id
  end

  def decr(film)
    set.decr film.id
  end

  def score_for(film_id)
    set.score film_id
  end

end