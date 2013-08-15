module Imdb
  class Client
    class << self

      def uri(id)
        id_path = id.kind_of?(Array) ? "ids=#{id.join(',')}" : "id=#{id}"
        "http://mymovieapi.com/?release=full&#{id_path}"
      end

      def request(imdb_id)
        Log.info "mymovieapi -> IMDB request to #{uri(imdb_id)}"
        JSON(RestClient.get uri(imdb_id))
      end
    end
  end
end