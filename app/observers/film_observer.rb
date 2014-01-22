class FilmObserver < ActiveModel::Observer

  def film_details_updated(film)
    Log.debug "#{film.provider} film details updated for film: #{film.id}"
    update_imdb_info film    
  end

  def after_create(film)
    Log.debug "Film #{film.id} created from #{film.provider} details"
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
      Log.debug("Film #{film.id} already has UK release date")
      return
    end

    # unless imdb_provider.fetched_at.blank? 
    #   Log.debug("Film #{film.id} IMDB details already retrieved")
    #   return
    # end

    Log.debug "Finding IMDB info for film: #{film.id}"


    return unless imdb_movie = Imdb::Movie.find_or_fetch(imdb_provider.reference)
    imdb_movie.add_movie_provider
    # film.set_release_date(imdb_movie.release_date_for('UK'), 'UK')
    film

    rescue Exception => msg
      Log.error "Unable to update IMDB details: #{msg}"
      film
  end


end