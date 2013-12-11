class Film < ActiveRecord::Base

  self.primary_key = :id
  attr_accessible :id, :backdrop, :classification, :director, :fetched_at, 
                  :genres, :id, :popularity, :poster, :provider, :provider_id, 
                  :release_date, :release_date_country, :title, :title_director, :trailer,
                  :watched_counter, :loved_counter, :owned_counter

  extend FilmScopes

  # extend Queryable

  has_many    :providers,         class_name: 'FilmProvider'
  has_many    :entries,           class_name: 'FilmEntry',          :inverse_of => :film
  has_many    :recommendations,   class_name: 'FilmRecommendation', :inverse_of => :film

  validates_presence_of :provider
  validates_presence_of :provider_id
  validates_presence_of :title
  validates_presence_of :release_date
  

  # has_one :user_entry, class_name: 'FilmEntry', :conditions => lambda {|u| "film_entries.user_id = #{u.id}"}


  before_create :set_title_director

  def self.with_entries_for(user)
    user ? includes(:entries).joins("left outer join film_entries on films.id = film_entries.film_id and film_entries.user_id = #{ActiveRecord::Base.sanitize(user.id)} ") : self
  end

  def self.create_uuid(title, year)
    title = title.gsub("'","").parameterize
    "#{title}-#{year}" if (!title.empty? and year)
  end

  def self.fetch_from(movie)
    return unless movie 
    find_provider(movie) || create_from(movie)
  end

  def self.find_provider(movie)
    film = find_by_id(movie.title_id) if movie.title_id
    return film if film

    return unless movie.respond_to? :imdb_id 
    FilmProvider.find_by(:imdb, movie.imdb_id).film unless movie.imdb_id.blank?
  end


  def self.create_from(movie)
    return unless title_id = movie.title_id and movie.allowed?

    Log.debug("Creating film '#{title_id}' from provider '#{movie.provider}-#{movie._id}'")
    film = create(
      id: title_id, 
      fetched_at: Time.now.utc,
      title: movie.title,
      director: movie.directors_name,
      release_date: movie.release_date, 
      release_date_country: movie.release_date_country,
      poster: movie.poster, 
      backdrop: movie.backdrop,
      genres: movie.genres,
      trailer: movie.trailer,
      popularity: movie.popularity.to_f,
      classification: movie.classification,
      provider_id: movie._id, 
      provider: movie.provider.downcase)
    film.add_provider movie
    film
  rescue 
    Log.error "Could not create film of movie id: #{movie.id}, title_id: #{title_id}"
    nil
  end

  def details
    @details ||= "#{film_provider_class}::Movie".constantize.find provider_id
  end

  def details_presenter
    "#{film_provider_class}Presenter".constantize
  end

  def presenter
    details_presenter.new(details, details_presenter)
  end
  
  def year
    release_date.year if release_date
  end

  def score
    counts = entries.counts
    return 0 unless counts.watched > 0
    ((counts.loved.to_f / counts.watched.to_f) * 100).round(0)
  end


  def provider_for(name)
    providers.find_by_name name
  end

  def has_provider?(provider)
    providers.exists_for? provider
  end

  def add_provider(movie)
    providers.update_from(movie)
    set_imdb(movie.imdb_id) if movie.respond_to? :imdb_id
  end

  def set_imdb(id)
    providers.find_or_create(:imdb, id) if id
  end

  def set_title_director
    self.title_director = title_director_key
  end

  def title_director_key
    "#{title}__#{director}".parameterize
  end

  def set_release_date(date=nil, country)
    if date
      update_attributes!({
       release_date: date,
       release_date_country: country
      }) 
      Log.debug "Film #{id} release date set to #{date} for country #{country}"
    else
      Log.debug "No release date found for #{country}"
    end
    self
  end

  def film_provider_class
    provider.capitalize
  end

  def update_film_provider(film_provider)

    return if film_provider.respond_to? :not_allowed? and film_provider.not_allowed?

    update_attributes!({
      fetched_at: Time.now.utc,
      poster: film_provider.poster || poster,
      release_date: film_provider.release_date || release_date,
      release_date_country: film_provider.release_date_country || release_date_country,
      trailer: film_provider.trailer || trailer,
      genres: film_provider.genres || genres,
      backdrop: film_provider.backdrop || backdrop,
      classification: film_provider.classification || classification,
      popularity: film_provider.popularity || popularity,
      provider: film_provider.provider, 
      provider_id: film_provider.id
    })
    notify_observers :film_details_updated
    self
  end

  def update_counters
    counts = entries.counts
    self.watched_counter = counts.watched_count
    self.loved_counter = counts.loved_count
    self.owned_counter = counts.owned_count
    save
  end


  def to_param
    id
  end

end

