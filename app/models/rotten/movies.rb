module Rotten
  class Movies

    def self.import_all
      in_cinemas
      upcoming
      opening
    end

    def self.in_cinemas
      import Rotten::Client.in_cinemas
    end

    def self.upcoming
      import Rotten::Client.upcoming
    end

    def self.opening
      import Rotten::Client.opening
    end

    def self.import(films)
      films.map do |film_json| 
        movie = Movie.find_or_fetch(film_json['id'].to_i)
        movie.add_movie_provider
        movie
      end
    end
  end

end
