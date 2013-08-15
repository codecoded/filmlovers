module Netflix
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    before_upsert :set_film_provider

    field :_id, type: String
    field :film_id, type: String
    field :release_year, type: Integer
    field :title, type: String
    field :title_id, type: String
    field :rating, type: Integer
    field :url, type: String
    field :available_from, type: Date

    # def self.from_json(data)
    #   movie = new(data)
    #   movie.upsert
    #   movie
    # end

    def film
      @film ||= Film.find_by _title_id: title_id
    end

    def available?
      available_from.to_date < Date.today
    end

    def set_film_provider
      
      self.title_id = "#{title.parameterize}-#{release_year}"
      return unless film
      self.film_id = film.id
      film.provider_for(:netflix).tap do |film_provider|
        film_provider.providerId  = self.id || film_provider.providerId
        film_provider.link        = self.url || film_provider.link 
        film_provider.rating      = self.rating || film_provider.rating
        film_provider.save
      end
    end
  end
end