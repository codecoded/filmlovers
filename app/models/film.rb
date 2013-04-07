class Film
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: Integer, default: ->{ id.to_id if id}
  field :_title_id, type: String, default: ->{"#{title.parameterize}-#{year}"}
  field :fetched, type: DateTime, default: nil

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

  def year
    return unless release_date
    release_date.to_date.year
  end

  def director
    @director ||= credits.crew.find {|member| member['job']=='Director'}
    @director ? @director['name'] : ''
  end

  def trailer(source=:youtube)
    trailers[source.to_s][0]['source'] if has_trailer?(source)
  end

  def score_for(list_name)
    Films[list_name].score_for(id) || 0
  end

  def score
    watched = score_for :watched
    return 0 unless watched > 0
    ((score_for(:loved) / watched) * 100).round(0)
  end

  def to_param
    "#{title.parameterize}-#{year}"
  end

end

