class Film
  include Mongoid::Document

  field :_id, type: String, default: ->{ id }

  FilmLists = [:watched, :loved, :unloved, :queued]

  def self.fetch(id)
    FilmRepository.find id
  end
  
  def users
    @lists ||= FilmLoverLists.new("film:#{id}:users")
  end

  def credits
    @credits ||= Credits.new casts
  end

  def images_library
    @images = Images.new(self.images)
  end

  def has_poster?
    poster_path
  end

  def poster(size='original')
    AppConfig.image_uri_for [size, poster_path] if poster_path
  end

  def has_backdrop?
    backdrop_path
  end

  def backdrop(size='original')
    AppConfig.image_uri_for [size, backdrop_path] if has_backdrop?
  end

  def has_trailer?(source=:youtube)
    !trailers[source.to_s].blank?
  end

  def trailer(source=:youtube)
    trailers[source.to_s][0]['source'] if has_trailer?(source)
  end

end

