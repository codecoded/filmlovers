module Imdb
  class Movie < MovieProvider
    include Mongoid::Document
    include Mongoid::Timestamps

    def self.find_or_fetch(id)  
      find(id) || fetch(id)
    end

    def self.fetch(id)  
      movie_data = Client.movie(id)
      return unless movie_data and movie_data['imdbID']
      movie = with(safe:false).new(Client.movie(id))
      movie.upsert
      movie
    end

    def self.fetch!(id)
      fetch(id).set_film_provider!
    end

    def film
      @film = super
      # @film.set_release_date release_date_for('UK'), 'UK'
    end

    def id
      self['imdbID']
    end
    
    def title
      self['Title']
    end

    def year
      self['Year']
    end

    def link
      "http://www.imdb.com/title/#{id}"
    end

    def rating
      self['imdbRating']
    end

    def release_date?
      release_date
    end

    def release_date
      date = self['Released']
      Date.parse (date) if date
    end

    def poster
      self['Poster']
    end
  end
end