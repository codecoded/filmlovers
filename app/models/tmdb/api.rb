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
  end
end