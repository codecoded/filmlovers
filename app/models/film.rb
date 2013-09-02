class Film
  extend FilmScopes
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,                 type: String
  field :classification,        type: String
  field :release_date,          type: Date
  field :release_date_country,  type: String
  field :fetched_at,            type: DateTime, default: nil
  field :poster,                type: String
  field :trailer,               type: String
  field :details_provider,      type: String,   default: :tmdb

  embeds_one :details, class_name: "FilmDetails", autobuild: true
  embeds_one :counters, class_name: "FilmCounters", autobuild: true
  embeds_many :providers, class_name: 'FilmProvider'

  index({ id: 1, release_date: -1, title: 1}, { unique: true, name: "film_index", background: true })
  index({ 'details._id' => 1}, { unique: true, name: "film_details_index", background: true })
  index "details.popularity" => -1
  # has_many :film_user_actions, validate: false, dependent: :destroy
  has_many :recommendations, as: :recommendable

  def self.create_uuid(title, year)
    "#{title.gsub("'","").parameterize}-#{year}" 
  end

  def self.find_by_provider(name, id)
    find_by('providers.name'=> name.to_s, 'providers._id' => id)
  end

  def entries
    @entries ||= FilmEntry.where('film._id' => self.id)
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

  def provider_by(name, id)
    providers.find_or_initialize_by name: name, id: id
  end

  def provider_for(name)
    providers.find_by name: name
  end

  def add_provider(name, provider)
    provider_by(name, provider.id).tap do |film_provider|
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

  def has_provider?(name)
    providers.where(:name => name).exists?
  end

  def details_presenter
    "#{details_provider.capitalize}Presenter".constantize
  end

  def update_details(provider, details)
    update_attributes!({
      fetched_at: Time.now.utc,
      details_provider: provider, 
      details: FilmDetails.new(details)
    })
    notify_observers :film_details_updated
    self
  end

  def to_param
    id
  end

  def method_missing(method, *args)
    details ? details.send(method, args) : super
  end

end

