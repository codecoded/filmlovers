class Film
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :film_user_actions, validate: false, dependent: :destroy
  embeds_one :counters, class_name: "FilmCounters", autobuild: true

  # has_many :film_list_items, validate: false, dependent: :destroy

  field :_id, type: Integer, default: ->{ id.to_id if id}
  field :_title_id, type: String, default: ->{"#{title.parameterize}-#{year}"}
  field :fetched, type: DateTime, default: nil
  field :rating, type: Integer, default: 0
  field :tms_id, type: String
  field :rotten_id, type: String
  field :uk_rating, type: String

  FilmLists = [:watched, :loved, :unloved, :queued]

  has_many :recommendations, as: :recommendable

  index({ title: 1}, { name: "film_title_index", background: false })
  index({ release_date: 1}, { name: "film_release_date_index", background: false })
  index({ popularity: 1}, { name: "film_popularity_index", background: false })

  def self.fetch(id)
    FilmRepository.find id
  end

  def self.find_or_create(film)
    find(film['id']) || with(safe:false).create(film)
  end

  def self.force_fetch(id)
    FilmRepository.new(id).send :fetch
  end

  def title
    self['title']
  end

  def users
    @lists ||= FilmLoverLists.new("film:#{id}:users")
  end

  def credits
    @credits ||= Credits.new casts if casts
  end

  def images
    self[:images]
  end

  def images_library
    @images = Images.new(images) if images
  end

  def trailers
    self[:trailers]
  end

  def casts
    self[:casts]
  end

  def overview
    self[:overview]
  end

  def runtime
    self[:runtime]
  end

  def has_poster?
    self[:poster_path]
  end

  def poster(size='original')
    AppConfig.image_uri_for [size, poster_path] if poster_path
  end

  def studios?
    production_companies and production_companies.length > 0
  end

  def release_date
    self['release_date'].to_date if self['release_date']
  end

  def duration
    runtime if runtime and runtime.to_i > 0  
  end

  def backdrop_path
    self[:backdrop_path]
  end
  
  def has_backdrop?
    backdrop_path and images
  end

  def backdrops
    images_library.backdrops
  end

  def has_trailer?(source=:youtube)
    trailers and !trailers[source.to_s].blank?
  end

  def year
    return if release_date.blank?
    release_date.to_date.year
  end

  def has_director?
     crew_member 'Director'
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

  def uk_release_date
    @uk_release_date ||= releases['countries'].find {|r| r['iso_3166_1']=='GB'}
    @uk_release_date['release_date'] if @uk_release_date
  end

  def self.search(query, field=:title, order=:title, by=:asc)
    order_by([order, by]).any_of({title: /#{query}/i}, {original_title: /#{query}/i}).where(adult: false)
  end

end

