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
      next unless film
      [:watched, :loved, :owned].each do |action|
        film.counters.set(action, film.actions_for(action).count)
      end
    end
  end
end