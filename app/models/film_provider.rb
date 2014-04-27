class FilmProvider < ActiveRecord::Base
  belongs_to :film
  attr_accessible :fetched_at, :link, :name, :reference, :rating, :storefront_ids


  def self.apple_affiliate_link(film, storefront_id=143444)
    itunes_url = "http://ax.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=movie&country=GB&term=#{film.title}"
    apple_provider = apple(storefront_id)
    apple_provider ?  apple_provider.aff_link :  "http://clkuk.tradedoubler.com/click?p=23708&a=2247239&g=19223668&url=#{itunes_url}&partnerId=2003"   
  end


  def self.apple(storefront_id=143444)
    apple_provider = where(name: :apple).first
    return unless apple_provider

    apple_provider.storefront_ids.include?(storefront_id.to_s) ? apple_provider : nil
  end

  def self.find_by(name, reference)
    where(name: name.downcase, reference: reference.to_s).first_or_initialize
  end


  def self.find_or_create(provider, reference)
    return if reference.blank?
    where(name: provider.downcase, reference: reference.to_s).first_or_create
  end

  def self.exists_for?(provider)
    where(name: provider).exists?
  end

  def self.update_from(movie)
    storefront_ids = nil
    if movie.provider == "apple"
      storefront_ids = movie.storefront_ids
    end
    # return if has_provider? provider.provider
    find_by(movie.provider, movie.id.to_s).tap do |film_provider|
      film_provider.link            = movie.link    || film_provider.link
      film_provider.rating          = movie.rating  || film_provider.rating
      film_provider.fetched_at      = Time.now.utc
      film_provider.storefront_ids  = storefront_ids
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
      # when :apple; (link.index('?') ? "#{link}&partnerId=2003&TDUID=UK2247239" : "#{link}?partnerId=2003&TDUID=UK2247239").gsub('/video/','/gb/movie/')
      # when :apple; "http://clkuk.tradedoubler.com/click?p=23708&a=2247239&&url=#{CGI.escape(link + '&partnerId=2003')}"
      when :imdb; "http://www.imdb.com/title/#{reference}"
      else; link
    end
  end

  def sym_name
    name.downcase.to_sym
  end

end
