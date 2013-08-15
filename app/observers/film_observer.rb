class FilmObserver < Mongoid::Observer


  def after_upsert(film)
    update_counters film
    update_imdb_info film
  end

  def update_counters(film)
    film.update_counters
  end

  def update_imdb_info(film)
    return if film.has_provider?(:imdb)
    Log.debug "Fetching IMDB info for film: #{film._title_id}"
    Thread.new do
      Imdb::Movie.fetch film.imdb_id if film.imdb_id
    end
  end


end