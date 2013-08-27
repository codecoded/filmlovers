class FilmObserver < Mongoid::Observer

  def film_details_updated(film)
    Log.debug "#{film.details_provider} film details updated for film: #{film.id}"
    update_imdb_info film    
  end

  def after_create(film)
    Log.debug "Film #{film.id} created from #{film.details_provider} details"
    update_imdb_info film
  end

  def update_counters(film)
    # film.update_counters
  end

  def update_imdb_info(film)
    imdb_provider = film.provider_for :imdb

    unless imdb_provider 
      Log.debug("Film #{film.id} has no IMDB provider details") 
      return 
    end

    if film.release_date_country == 'UK'
      Log.debug("Film #{film.id} already has updated release date")
      return
    end

    # unless imdb_provider.fetched_at.blank? 
    #   Log.debug("Film #{film.id} IMDB details already retrieved")
    #   return
    # end

    Log.debug "Finding IMDB info for film: #{film.id}"

    return unless imdb_movie = Imdb::Movie.find(imdb_provider.id)
    film.add_provider(:imdb, imdb_movie)
    film.set_release_date(imdb_movie.release_date_for('UK'), 'UK')
    film
  end


end