module AppConfig
  extend self

  attr_accessor :ios_app, :page_size

  @ios_app    = 'filmlovr_app'
  @page_size  = 21

  def setup(&block)
    yield self if block_given?
  end

  def instance
     @config ||= OpenStruct.new Tmdb::Config.get
  end

  def images
    @images ||= OpenStruct.new instance.images
  end

  def image_uri_for(append_to_base)
    File.join [images.base_url, append_to_base]
  end
    
  def update_counters
    film_ids = FilmEntry.only(:film_id).pluck(:film_id).uniq    
    film_ids.each do |id|
      film = Film.find id
      film.counters.refresh if film
    end
  end
end