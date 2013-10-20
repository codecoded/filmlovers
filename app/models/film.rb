class Film
  extend FilmScopes
  extend Queryable
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,                 type: String
  field :classification,        type: String
  field :release_date,          type: Date
  field :release_date_country,  type: String
  field :fetched_at,            type: DateTime, default: nil
  field :poster,                type: String
  field :trailer,               type: String
  field :genres,                type: Array
  field :popularity,            type: Float
  field :provider_id,           type: Integer
  field :provider,              type: String,   default: :tmdb

  # embeds_one :details, class_name: "FilmDetails", autobuild: true
  embeds_one  :counters,  class_name: "FilmCounters", autobuild: true
  embeds_many :providers, class_name: 'FilmProvider'

  index({ release_date: -1 }, { unique: false, name: "film_release_date_index", background: true })
  index({ title: -1 }, { unique: true, name: "film_title_index", background: true })
  index({ genres: -1 }, { unique: false, name: "film_genres_index", background: true })
  index({ popularity: -1 }, { unique: false, name: "film_popularity_index", background: true })
  index({ provider: 1, provider_id: 1}, { unique: true, name: "provider_index", background: true })

  index({ 'counters.watched'=> -1 }, { unique: false, name: "film_counters_watched", background: true })
  index({ 'counters.loved'  => -1 }, { unique: false, name: "film_counters_loved", background: true })
  index({ 'counters.owned'  => -1 }, { unique: false, name: "film_counters_owned", background: true })

  def self.create_uuid(title, year)
    "#{title.gsub("'","").parameterize}-#{year}" 
  end

  def self.find_by_provider(name, id)
    find_by('providers.name'=> name.to_s, 'providers._id' => id)
  end

  def self.create_from(provider)
    Log.debug("Creating film '#{provider.title_id}' from provider '#{provider.name}-#{provider._id}'")
    film = create(
      id: provider.title_id, 
      fetched_at: Time.now.utc,
      title: provider.title,
      release_date: provider.release_date, 
      release_date_country: provider.release_date_country,
      poster: provider.poster, 
      genres: provider.genres,
      trailer: provider.trailer,
      popularity: provider.popularity,
      classification: provider.classification,
      provider_id: provider._id, 
      provider: provider.name) 
    film.counters.save
    film 
  end

  def entries
    @entries ||= FilmEntry.where(film_id: self.id)
  end
 
  def details
    @details ||= "#{film_provider_class}::Movie".constantize.find provider_id
  end

  def details_presenter
    "#{film_provider_class}Presenter".constantize
  end

  def actions_for(action)
    entries.find_by_action(action)
  end
  
  def year
    release_date.year if release_date
  end

  def score
    watched = actions_for(:watched).count
    return 0 unless watched > 0
    ((actions_for(:loved).count / watched) * 100).round(0)
  end

  def poster?
    poster
  end

  def trailer?
    trailer
  end

  def has_provider?(name)
    providers.where(:name => name).exists?
  end

  def provider_by(name, id)
    providers.find_or_initialize_by name: name, id: id
  end

  def provider_for(name)
    providers.find_by name: name
  end

  def add_provider(provider)
    return if has_provider? provider.name
    provider_by(provider.name, provider.id).tap do |film_provider|
      film_provider.link        = provider.link || film_provider.link
      film_provider.rating      = provider.rating || film_provider.rating
      film_provider.fetched_at  = Time.now.utc
      film_provider.save
    end    
    self
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
    update_attributes!({
      fetched_at: Time.now.utc,
      popularity: film_provider.popularity,
      provider: film_provider.name, 
      provider_id: film_provider.id
    })
    notify_observers :film_details_updated
    self
  end

  def to_param
    id
  end

end

