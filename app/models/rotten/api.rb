class Rotten::API

  class << self

    def request(method, params={})
      Log.info "send request to Rotten Tomatoes #{uri(method)}, #{add_api_key(params)}"
      JSON(RestClient.get uri(method), add_api_key(params))
    end

    def uri(method)
       "#{Rotten.api}#{method}"
    end

    def add_api_key(params)
      {params: {apikey:Rotten.key, country: 'uk'}.merge(params)}
    end
    
    def in_cinemas
      request '/lists/movies/in_theaters.json'
    end

    def upcoming
      request '/lists/movies/upcoming.json'
    end

  end

end