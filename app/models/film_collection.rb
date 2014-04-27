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
      @coll.film_ids = Film.coming_soon.map &:id
      @coll.save
    end

    def in_cinemas
       find_or_create_by(name: "In Cinemas")
    end

    def populate_in_cinemas
      @coll = in_cinemas
      @coll.film_ids = Film.in_cinemas.compact.map &:id
      @coll.save
    end
  end

  def films
    @films ||= Film.where(id: film_ids).where('poster is not null')
  end

end