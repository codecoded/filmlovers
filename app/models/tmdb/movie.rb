module Tmdb
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
      @film.add_provider(:tmdb, self)
      @film.provider_by(:imdb, imdb_id).save if imdb_id?
      @film
    end

    def find_film
      Film.find title_id
    end

    def id
      movie_data['id']
    end

    def imdb_id
      @imdb_id ||= movie_data['imdb_id']
    end

    def imdb_id?
      movie_data['imdb_id']
    end

    def title_id
      @title_id ||= Film.create_uuid(title, year)
    end

    def title
      @title ||= movie_data['title']
    end

    def year
      @year ||= initial_release_date.year
    end

    def link
      "http://www.themoviedb.org/movie/#{id}"
    end

    def rating
      movie_data['popularity']
    end

    def poster
      @poster ||= movie_data['poster_path']
    end

    def initial_release_date
      @initial_release_date ||= movie_data['release_date'].to_date
    end

    def release_date
      if uk_release = release_date_for('GB') 
        uk_release['release_date'].to_date
      else
        initial_release_date
      end
    end

    def releases
      @releases ||= movie_data['releases']
    end

    def release_date_for(country)
      return if releases['countries'].blank?
      releases['countries'].find {|r| r['iso_3166_1']==country}
    end

    def not_allowed?
      !release_date || movie_data['adult']
    end

    def set_film_details!
      return if not_allowed?
      film.update_details :tmdb, movie_data
    end

    protected

    def create_film
      return nil if not_allowed?
      Log.debug("Creating film from tmdb data: #{title_id}")
      Film.create(
        id: title_id, 
        fetched_at: Time.now.utc,
        title: title,
        release_date: release_date, 
        poster: poster, 
        details: FilmDetails.new(movie_data), 
        details_provider: :tmdb)
    end



  end
end