class Tmdb::API

  class << self

    def request(method, params={})
      Log.info "send request to #{uri(method)}, params: #{add_api_key(params)}"
      JSON(RestClient.get uri(method), add_api_key(params))
    end

    def uri(method)
       "#{Tmdb.api}#{method}"
    end

    def add_api_key(params)
      {params: {api_key:Tmdb.key}.merge(params)}
    end

    def new_get_request(url, params={})
      RestClient::Request.new(method: :get, url: uri(url), headers: add_api_key(params))
    end

    def genre(id, options={})
      request "genre/#{id}/movies", options
    end

    def genres(options={})
      request "genre/list", options
    end

    def search(query, options={}, type=:movie)
      request "search/#{type}", {query: query}.merge(options)
    end

    def films(type, options={})
      request "movie/#{type}",options
    end

    def list(id, options={})
      request "list/#{id}", options
    end
  end

end