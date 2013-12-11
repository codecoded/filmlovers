module AppConfig
  extend self

  attr_accessor :ios_app, :page_size, :itunes_affiliate

  @ios_app    = 'filmlovr_app'
  @page_size  = 21
  @itunes_affiliate = '10lne2'

  def setup(&block)
    yield self if block_given?
  end

  def instance
     @config ||= OpenStruct.new Tmdb::Config.get
  end

  def images
    @images ||= OpenStruct.new instance.images
  end

  def image_uri_for(append_to_base)
    File.join [images.base_url, append_to_base]
  end
    

end