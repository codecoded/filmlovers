class FilmProvider
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :film, autobuild: true

  field :name,            type: String
  field :link,            type: String
  field :rating,          type: Float
  field :fetched_at,      type: DateTime, default: nil

  def fetch
    klass.fetch id
  end

  def fetch!
    klass.fetch! id
  end


  def klass
    @klass ||= "#{name.capitalize}::Movie".constantize
  end
end