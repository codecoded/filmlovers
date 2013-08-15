module Rotten
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    before_upsert :set_film_provider

    field :film_id, type: Integer

    def self.from_json(data)
      movie = new(data)
      movie.upsert
      movie
    end

    def imdb_id
      "tt#{self['alternate_ids']['imdb']}" if (self['alternate_ids'] and  self['alternate_ids']['imdb'])
    end

    def film
      @film ||= Film.find_by(imdb_id: imdb_id)
    end

    def set_film_provider
      if film
        self.film_id = film.id
        film.provider_for(:rotten).tap do |film_provider|
          film_provider.providerId  = self.id
          film_provider.link        = self.links['alternate']
          film_provider.rating      = self.ratings['critics_score']
          film_provider.save
        end
      end
    end
  end
end