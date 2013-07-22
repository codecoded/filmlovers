class FilmCollection
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,  type: String
  field :film_ids, type: Array

  class << self
    def coming_soon
       find_or_create_by(name: "Coming Soon")
    end

    def populate_coming_soon
      @coll = coming_soon
      @coll.film_ids = Films.coming_soon.only(:id).map &:id
      @coll.save
    end

    def in_cinemas
       find_or_create_by(name: "In Cinemas")
    end

    def populate_in_cinemas
      @coll = in_cinemas
      @coll.film_ids = Films.in_cinemas
      @coll.save
    end
  end

  def films
    @films ||= Film.in(id: film_ids)
  end

end