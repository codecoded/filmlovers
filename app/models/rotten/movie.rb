module Rotten 
  class Movie < MovieProvider
    include Mongoid::Document
    include Mongoid::Timestamps

    def provider
      self.class.name.deconstantize.downcase
    end    

    def self.find_or_fetch(id)  
      find(id) || fetch(id)
    end

    def self.fetch(id)  
      movie = with(safe:false).new(Client.movie(id))
      movie.upsert
      movie
    end

    def self.fetch!(id)
      fetch(id).set_film_provider!
    end

    def imdb_id
      "tt#{self['alternate_ids']['imdb']}" if imdb_id?
    end

    def presenter
      @presenter ||= RottenPresenter.new self, Rotten::Movie
    end

    def directors_name
      presenter.director if presenter.director?
    end

    def title
      self['title']
    end

    def year
      self['year']
    end

    def link
      self['links']['alternate']
    end

    def rating
      self['ratings']['critics_score']
    end

    def release_date
      self['release_dates']['theater'] if self['release_dates']
    end

    def poster
      self['posters']['detailed'] if self['posters']
    end

    def imdb_id?
      self['alternate_ids'] and self['alternate_ids']['imdb']
    end

    def genres
      self['genres'] || {}
    end

    def classification
      self['mpaa_rating']
    end

  end
end