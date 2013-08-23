module Imdb
  class Movie

    attr_reader :movie_data

    def initialize(movie_data)
      @movie_data = movie_data
    end

    def self.find(id)
      movie_data =  Client.movie(id)
      new(movie_data) if movie_data and movie_data['imdb_id']
    end

    def self.fetch(id)
      find(id).film
    end

    def self.fetch!(id)
      find(id).set_film_details!
    end

    def self.find_all(ids)
      movies = Client.movies(ids)
      movies.map {|movie| new(movie) }
    end

    def self.fetch_all(ids)
      find_all(ids).map &:film
    end

    def film
      @film ||= find_film || create_film
      @film.add_provider(:imdb, self)
      @film.set_release_date release_date_for('UK'), 'UK'
    end

    def find_film
      Film.or(
        {'providers.name' => :imdb, 'providers._id' => id},
        {_id: title_id}).first
    end

    def id
      movie_data['imdb_id']
    end

    def title_id
      Film.create_uuid(title, year)
    end

    def title
      @title ||= movie_data['title']
    end

    def year
      @year ||= movie_data['year']
    end

    def link
      movie_data['imdb_url']
    end

    def rating
      movie_data['rating']
    end

    def release_dates?
      release_dates
    end

    def release_dates
      @release_dates ||= movie_data['release_date'] || {}
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
      return unless date
      Date.new(date['year'], date['month'], date['day'])
    end

    def poster
      movie_data['poster']['cover']
    end

    def set_film_details!
      film.update_details :imdb, movie_data
    end

    protected
    def create_film
      Log.debug("Creating film from IMDB data: #{title_id}")
      release_date_country = 'UK' if release_date_for('UK')

      Film.create(
        id: title_id, 
        fetched_at: Time.now.utc,
        title: title, 
        release_date: release_date, 
        release_date_country: release_date_country,
        poster: poster, 
        details: FilmDetails.new(movie_data), 
        details_provider: :imdb)
    end



  end
end