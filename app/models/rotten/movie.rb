module Rotten
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    def identifier
      self.class.name.deconstantize
    end    

    def self.find_or_fetch(id)  
      find(id) || fetch(id)
    end

    def self.fetch(id)  
      with(safe:false).create(Client.movie(id))
    end

    def self.fetch!(id)
      fetch(id).set_film_provider!
    end

    def film
      @film = (find_film || create_film)
      @film.add_provider(self)
      @film.provider_by(:Imdb, imdb_id).save if imdb_id?
      @film
    end

    def find_film
      Film.where(_id: title_id).first || Film.find_by_provider(:Imdb, imdb_id)
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


    def title_id
      Film.create_uuid(title, year)
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
  
    def release_date_country
      nil
    end

    def trailer
      nil
    end

    def popularity
      0
    end

    def classification
      self['mpaa_rating']
    end

    def set_film_provider!
      film.update_film_provider self
    end

    protected
    def create_film
      Log.debug("Creating film from #{identifier} data: #{title_id}")
      Film.create_from(self)
    end

  end
end