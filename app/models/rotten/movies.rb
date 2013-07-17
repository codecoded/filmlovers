module Rotten
  class Movies

    def self.in_cinemas
      Rails.cache.fetch 'rotten_in_cinemas', expires_in: 4.hours do
        import Rotten::Client.in_cinemas
      end
    end

    def self.upcoming
      Rails.cache.fetch 'rotten_upcoming', expires_in: 4.hours do
        import Rotten::Client.upcoming
      end
    end

    def self.opening
      Rails.cache.fetch 'rotten_opening', expires_in: 4.hours do
        import Rotten::Client.opening
      end
    end

    def self.import(films)
      films.map {|film| Movie.find_or_create film}
    end
  end

end
