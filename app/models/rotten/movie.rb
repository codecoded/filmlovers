module Rotten
  class Movie

    attr_reader :movie_data

    def initialize(movie_data)
      @movie_data = movie_data
    end

    def self.find(id)
      new Client.movie(id)
    end

    def self.fetch(id)
      find(id).film
    end

    def self.fetch!(id)
      find(id).set_film_details!
    end

    def film
      @film ||= find_film || create_film
      @film.add_provider(:rotten, self)
      @film.provider_by(:imdb, imdb_id).save if imdb_id?
      @film
    end

    def find_film
      Film.or(
        {'providers.name' => :imdb, 'providers._id' => imdb_id},
        {_id: title_id}).first
    end

    def id
      movie_data['id']
    end

    def imdb_id
      "tt#{movie_data['alternate_ids']['imdb']}" if imdb_id?
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
      movie_data['links']['alternate']
    end

    def rating
      movie_data['ratings']['critics_score']
    end

    def release_date
      movie_data['release_dates']['theater'] if movie_data['release_dates']
    end

    def poster
      movie_data['posters']['detailed'] if movie_data['posters']
    end

    def imdb_id?
      movie_data['alternate_ids'] and movie_data['alternate_ids']['imdb']
    end

    def set_film_details!
      film.update_details :tmdb, movie_data
    end
    
    protected

    def create_film
      Log.debug("Creating film from Rotten data: #{title_id}")
      Film.create(
        id: title_id, 
        fetched_at: Time.now.utc,
        title: title, 
        release_date: release_date, 
        poster: poster, 
        details: FilmDetails.new(movie_data), 
        details_provider: :rotten)
    end


  end
end