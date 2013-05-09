class AppConfig

  field :fetched_index, type: Integer, default: 1

  class << self

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


end