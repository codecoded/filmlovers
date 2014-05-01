module AppConfig
  extend self

  attr_accessor :ios_app, :page_size, :itunes_affiliate, :storefront_id

  @ios_app            = 'filmlovr_app'
  @page_size          = 21
  @itunes_affiliate   = '10lne2'
  @itunes_partner_id  = 2003
  @storefront_id      = 143441 #143444 for uk, 143441 for US

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