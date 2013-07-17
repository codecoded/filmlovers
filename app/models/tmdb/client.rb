class Tmdb::Client

  class << self

    def request(method, params={})
      Log.info "send request to #{uri(method)}, params: #{add_api_key(params)}"
      JSON(RestClient.get uri(method), add_api_key(params))
    end

    def uri(method)
       "#{Tmdb.api}#{method}"
    end

    def add_api_key(params)
      {params: {api_key:Tmdb.key, per_page:50}.merge(params)}
    end
    
    def genre(id, options={})
      cache_key = "genre_#{id}_page_" + (options[:page].to_s || '1')
      Rails.cache.fetch cache_key, expires_in: 4.hours  do
        request "genre/#{id}/movies", options
      end
    end

    def genres(options={})
      Rails.cache.fetch "genres", expires_in: 4.hours  do
        request "genre/list", options
      end
    end

    def search(query, options={}, type=:movie)
      request "search/#{type}", {query: query}.merge(options)
    end

    def films(type, options={})
      cache_key = "films_#{type}_page_" + (options[:page].to_s || '1')
      Rails.cache.fetch cache_key, expires_in: 4.hours do
        request "movie/#{type}",options
      end
    end

    def list(id, options={})
      request "list/#{id}", options
    end

    def changes(type, options={})
      request "#{type}/changes", options
    end

  end

end