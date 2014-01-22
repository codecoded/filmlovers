module Imdb
  class Client
    class << self

      def uri
        "http://www.omdbapi.com/"
      end

      def request(params)
        Log.info "omdbapi -> IMDB request to #{uri}?#{params.to_query}"
        JSON(RestClient.get  uri, {params: params})
      end

      def movie(imdb_id)
        request({plot:'full', i: imdb_id})
      end

    end
  end
end