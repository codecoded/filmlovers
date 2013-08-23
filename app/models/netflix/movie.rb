module Netflix
  class Movie
    include Mongoid::Document


    field :_id, type: String
    field :film_id, type: String
    field :release_date, type: Date
    field :poster, type: String
    field :release_year, type: Integer
    field :title, type: String
    field :title_id, type: String
    field :rating, type: Integer
    field :link, type: String
    field :available_from, type: Date

    attr_reader :movie_data

    # def initialize(movie_data)
    #   @movie_data = movie_data
    # end

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
      @film.add_provider(:netflix, self)
      @film
    end

    def find_film
      Film.find title_id
    end

    def title_id
      @title_id ||= Film.create_uuid(title, release_year)
    end

    def set_film_details!
      film.update_details :netflix, movie_data
    end

    protected

    def create_film
      Log.debug("Creating film from Netflix data: #{title_id}")
      Film.create(
        id: title_id, 
        title: title,
        release_date: Date.new(release_year), 
        poster: poster, 
        details: self, 
        details_provider: :netflix)
    end


  end
end