module Rotten
  class Movies

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
      films.map {|film| Movie.find_or_create film}
    end
  end

end
