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
  field :netflix_id, type: String
  field :uk_rating, type: String

  FilmLists = [:watched, :loved, :unloved, :queued]

  has_many :recommendations, as: :recommendable

  index({ title: 1}, { name: "film_title_index", background: false })
  index({ release_date: 1}, { name: "film_release_date_index", background: false })
  index({ popularity: 1}, { name: "film_popularity_index", background: false })
  index({ genres: 1}, { name: "film_genres_index", background: true })


  def self.fetch(id)
    FilmRepository.find id
  end

  def self.find_or_create(film)
    find(film['id']) || with(safe:false).create(film)
  end

  def self.force_fetch(id)
    FilmRepository.new(id).send :fetch
  end

  def self.by_decade(decade)
    endDate = Date.new(decade.to_i+10)
    between(release_date: Date.new(decade.to_i).to_s..endDate.to_s)
  end

  def self.by_year(year)
    endYear = Date.new(year.to_i) + (1.year)
    between(release_date: Date.new(year.to_i).to_s...endYear.to_s)
  end

  def self.by_genres(genres)
    any_in('genres.name' => genres)
  end

  def title
    self['title']
  end

  def budget
    self['budget']
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

  def backdrop(size='original')
    AppConfig.image_uri_for([size, backdrops[0]['file_path']]) if has_backdrop?
  end

  def release_date
    @release_date ||= self['release_date'].to_date if self['release_date'] and !self['release_date'].blank?
  end

  def duration
    runtime if runtime and runtime.to_i > 0  
  end

  def backdrop_path
    self[:backdrop_path]
  end
  
  def has_backdrop?
    !backdrops.blank?
  end

  def backdrops_urls_for(size)
    backdrops.map {|b| AppConfig.image_uri_for [size, b['file_path']] } if has_backdrop?
  end

  def backdrops
    images_library ? images_library.backdrops : []
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
    return '' unless crew?
    credits.crew.find {|member| member['job']==job}
  end

  def cast?
    credits and !credits.cast.blank?
  end

  def crew?
    credits and !credits.crew.blank?
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
    !similar_movies['results'].blank?
  end

  def similar
    similar_movies['results'].compact.map {|f| Film.new(f)}
  end

  def actions_for(action)
    film_user_actions.where(action: action)
  end

  def uk_release
    @uk_release ||= release_for 'GB'
  end

  def uk_release_date
    @uk_release ? uk_release['release_date'] : release_date
  end

  def uk_certification
    uk_release['certification'] if @uk_release
  end

  def starring(count=3)
    credits.cast.take(count).map(&:name) if credits
  end

  def alternative_titles
    self['alternative_titles']['titles'] if alternative_titles?
  end

  def alternative_titles?
    self['alternative_titles']
  end

  def studios?
    !production_companies.blank?
  end

  def locations?
    !production_countries.blank?
  end

  def genres?
    self['genres']
  end

  def genres
    self['genres']
  end

  def spoken_languages
    self['spoken_languages']
  end

  def not_allowed?
    !release_date || self['adult']
  end

  def production_companies
    self['production_companies']
  end

  def production_countries
    self['production_countries']
  end

  def status
    self['status']
  end

  def tagline
    self['tagline']
  end
  
  def release_for(country_code)
    return unless !releases['countries'].blank?
    releases['countries'].find {|r| r['iso_3166_1']=='GB'}
  end

  def update_counters
    FilmLists.each do |action|
        counters.set(action, actions_for(action).count)
    end
  end
end

