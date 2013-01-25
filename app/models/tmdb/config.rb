class Tmdb::Config
   class << self
    def get
      Tmdb::API.request uri
    end

    def uri
      "configuration"
    end
  end 
end