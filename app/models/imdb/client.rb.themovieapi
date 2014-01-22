module Imdb
  class Client
    class << self

      def uri
        "http://mymovieapi.com/"
      end

      def request(params)
        Log.info "mymovieapi -> IMDB request to #{uri}?#{params.to_query}"
        JSON(RestClient.get  uri, {params: params})
      end

      def movie(imdb_id)
        request({release:'full', id: imdb_id})
      end

      def movies(imdb_ids)
        ids =  imdb_ids.join(',')
        request({release:'full', ids: ids})
      end
    end
  end
end