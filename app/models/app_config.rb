module AppConfig
  extend self

  def instance
     @config ||= OpenStruct.new Tmdb::Config.get
  end

  def images
    @images ||= OpenStruct.new instance.images
  end

  def image_uri_for(append_to_base)
    File.join [images.base_url, append_to_base]
  end

  def page_size
    21
  end
    
  def update_counters
    FilmUserAction.distinct(:film_id).each do |id|
      film = Film.find id
      film.update_counters if film
    end
  end
end