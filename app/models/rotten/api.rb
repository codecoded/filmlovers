class Rotten::Api

      class << self

        def page_limit
          50
        end

        def request(method, params={})
          Log.info "send request to Rotten Tomatoes #{uri(method)}, #{add_api_key(params)}"
          JSON(RestClient.get uri(method), add_api_key(params))
        end

        def uri(method)
           "#{Rotten.api}#{method}"
        end

        def add_api_key(params)
          {params: {apikey:Rotten.key, country: 'uk', page_limit: page_limit}.merge(params)}
        end
        
        def in_cinemas
          page_query '/lists/movies/in_theaters.json'
        end

        def opening
          page_query '/lists/movies/opening.json'
        end

        def upcoming
          page_query '/lists/movies/upcoming.json'
        end

        def page_query(query, page_no=1)
          results = request(query, page: page_no)
          movies = results['movies']
          next_link = results['links']['next']
          if next_link
            movies << page_query(query, page_no+1)
          end
          movies.flatten
        end
      end
end