class MovieProvider

  def provider
    self.class.name.deconstantize.downcase
  end    

  def film
    @film ||= Film.fetch_from self
  end

  def title_id
    Film.create_uuid(title, year)
  end

  def set_film_provider!
    film.update_film_provider(self) if allowed? and film
  end

  def title_director_key
    "#{title}__#{directors_name}".parameterize
  end

  def rating; 
    0.0
  end

  def not_allowed?
    false
  end

  def allowed?
    !not_allowed?
  end

  def title; end
  def year; end
  def directors_name; end
  def backdrop; end  
  def link; end
  def release_date; end
  def poster; end
  def genres; end
  def release_date_country; end
  def trailer; end
  def classification; end

end