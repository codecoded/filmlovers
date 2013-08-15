module Imdb
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    before_upsert :set_film_provider

    field :_id, type: String, default: -> {imdb_id}
    field :film_id, type: Integer

    def self.fetch(id)
      from_json Client.request(id)
    end

    def self.fetch_all(ids)
      movies = Client.request(ids)
      movies.map {|movie| from_json movie }
    end

    def self.from_json(data)
      movie = new(data).set_film_provider
      # movie.upsert
      movie
    end

    def film
      @film ||= Film.find_by(imdb_id: imdb_id)
    end

    def release_date_for(country)
      date = self['release_date'].find {|r| r['country']==country and r['remarks'].blank?} if self['release_date']
      return unless date
      Date.new(date['year'], date['month'], date['day'])
    end

    def set_film_provider
      if film
        self.film_id = film.id
        uk_release_date = release_date_for('UK')
        film.update_attribute(:uk_release_date, uk_release_date) if uk_release_date
        film.provider_for(:imdb).tap do |film_provider|
          film_provider.providerId  = self.id
          film_provider.link        = self['imdb_url']
          film_provider.rating      = self['rating']
          film_provider.save
        end
      end
    end
  end
end