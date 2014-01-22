module Imdb
  class Movie < MovieProvider
    include Mongoid::Document
    include Mongoid::Timestamps

    def self.find_or_fetch(id)  
      find(id) || fetch(id)
    end

    def self.fetch(id)  
      movie_data = Client.movie(id)
      return unless movie_data and movie_data['imdb_id']
      with(safe:false).create(movie_data)
    end

    def self.fetch!(id)
      fetch(id).set_film_provider!
    end

    def self.find_all(ids)
      movies = Client.movies(ids)
      movies.map {|movie| new(movie) }
    end

    def self.fetch_all(ids)
      find_all(ids).map &:film
    end

    def film
      @film = super
      @film.set_release_date release_date_for('UK'), 'UK'
    end

    def id
      self['imdb_id']
    end
    
    def title
      self['title']
    end

    def year
      self['year']
    end

    def link
      self['imdb_url']
    end

    def rating
      self['rating']
    end

    def release_dates?
      release_dates
    end

    def release_dates
      @release_dates ||= self['release_date'] || {}
    end

    def release_date?
      release_date
    end

    def release_date
      @release_date  ||= release_date_for('UK') || release_dates.first
    end

    def release_date_for(country)
      date = release_dates.find {|r| r['country']==country and r['remarks'].blank?} if release_dates?
      parse_release_date date
    end

    def parse_release_date(date)
      return unless date and date['year'] and date['month'] and date['day']
      Date.new(date['year'], date['month'], date['day'])
    end

    def poster
      self['poster']['cover']
    end
  end
end