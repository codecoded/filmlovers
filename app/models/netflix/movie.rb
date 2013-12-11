module Netflix < MovieProvider
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

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

    def self.find_or_fetch(id)  
      find(id) || fetch(id)
    end

    def self.fetch(id)
       with(safe:false).create(Client.movie(id))
    end

    def self.fetch!(id)
      find(id).set_film_provider!
    end

    def film
      @film ||= (find_film || create_film)
      @film.add_provider(self)
      @film
    end

    def find_film
      Film.find title_id
    end

    def title_id
      @title_id ||= Film.create_uuid(title, release_year)
    end

    def set_film_provider!
      film.update_film_provider self
    end

    protected

    def create_film
      Log.debug("Creating film from Netflix data: #{title_id}")
      Film.create(
        id: title_id, 
        title: title,
        release_date: Date.new(release_year), 
        poster: poster, 
        provider_id: _id, 
        provider: name)
    end

  end
end