class Film
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :film_user_actions, validate: false, dependent: :destroy
  # has_many :film_list_items, validate: false, dependent: :destroy

  field :_id, type: Integer, default: ->{ id.to_id if id}
  field :_title_id, type: String, default: ->{"#{title.parameterize}-#{year}"}
  field :fetched, type: DateTime, default: nil

  FilmLists = [:watched, :loved, :unloved, :queued]

  def self.fetch(id)
    FilmRepository.find id
  end

  def self.force_fetch(id)
    FilmRepository.new(id).send :fetch
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

  def studios?
    production_companies and production_companies.length > 0
  end

  def duration
    runtime if runtime and runtime.to_i > 0  
  end

  def has_backdrop?
    backdrop_path
  end

  def backdrops
    images_library.backdrops
  end

  def has_trailer?(source=:youtube)
    !trailers[source.to_s].blank?
  end

  def year
    return unless release_date
    release_date.to_date.year
  end

  def director
    @director ||= crew_member 'Director'
    @director ? @director['name'] : ''
  end

  def crew_member(job)
    return '' unless credits and credits.crew
    credits.crew.find {|member| member['job']==job}
  end

  def trailer(source=:youtube)
    trailers[source.to_s][0]['source'] if has_trailer?(source)
  end

  def score
    watched = actions_for(:watched).count
    return 0 unless watched > 0
    ((actions_for(:loved).count / watched) * 100).round(0)
  end

  def to_param
    "#{title.parameterize}-#{year}"
  end

  def similar?
    similar_movies
  end

  def similar
    similar_movies['results'].compact.map {|f| Film.find(f['id']) || Film.create(f)}
  end

  def actions_for(action)
    film_user_actions.where(action: action)
  end

end

