module Tmdb
  class Client
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

      def movie(id, with_attributes=[:all])
        Tmdb::Client.request("movie/#{id}", append_to_response(with_attributes))
      end

      def append_to_response(movie_methods)
        return {} if movie_methods.empty?
        methods = (movie_methods.member? :all) ? append_all : movie_methods
        {append_to_response: methods.join(',')}
      end

      def append_all
        [:alternative_titles, :casts, :images, :keywords, :releases, :trailers, :translations, :similar_movies]
      end 

      def changes(start_date = 1.day.ago, end_date = Time.now)
        Tmdb::Client.request "#{method}/changes", {start_date: start_date, end_date: end_date}
      end


      def genres(options={})
        # Rails.cache.fetch "genres", expires_in: 4.hours  do
          request "genre/list", options
        # end
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

      def changes(type, options={})
        request "#{type}/changes", options
      end

    end
  end
end