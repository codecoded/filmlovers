class FilmProvider < ActiveRecord::Base
  belongs_to :film
  attr_accessible :fetched_at, :link, :name, :reference, :rating

  def self.apple(storefront_id=143444)
    where(name: :apple, reference: storefront_id.to_s)
  end

  def self.find_by(name, reference)
    where(name: name, reference: reference.to_s).first_or_initialize
  end


  def self.find_or_create(provider, reference)
    return unless reference
    where(name: provider, reference: reference.to_s).first_or_create
  end

  def self.exists_for?(provider)
    where(name: provider).exists?
  end

  def self.update_from(movie)
    # return if has_provider? provider.provider
    find_by(movie.provider, movie.id.to_s).tap do |film_provider|
      film_provider.link            = movie.link    || film_provider.link
      film_provider.rating          = movie.rating  || film_provider.rating
      film_provider.fetched_at      = Time.now.utc
      film_provider.save
    end    
    self
  end

  def fetch
    klass.fetch id
  end

  def fetch!
    klass.fetch! id
  end

  def klass
    @klass ||= "#{name.capitalize}::Movie".constantize
  end

  def aff_link
    case sym_name
      when :apple; "#{link}&at=#{AppConfig.itunes_affiliate}".gsub('/video/','/gb/movie/')
      else; link
    end
  end

  def sym_name
    name.downcase.to_sym
  end

end
