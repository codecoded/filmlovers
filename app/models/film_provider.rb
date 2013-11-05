class FilmProvider
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :film

  field :name,            type: String
  field :link,            type: String
  field :rating,          type: Float
  field :fetched_at,      type: DateTime, default: nil

  def self.apple(storefront_id=143444)
    where(name: 'Apple').in(storefront_ids: storefront_id) || []
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

  def self.apple_affiliate_link(film, storefront_id=143444)
    itunes_url = "http://ax.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=movie&country=GB&term=#{film.title}"
    apple_provider = apple(143444).first
    apple_provider ?  apple_provider.aff_link :  "http://clkuk.tradedoubler.com/click?p=23708&a=2247239&g=19223668&url=#{itunes_url}&partnerId=2003"   
  end
end