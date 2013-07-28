module Netflix
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    # after_create :set_film_id

    # field :_id, type: String, default: ->{ self.TMSId }
    field :film_id, type: Integer
    field :year, type: Integer
    field :title, type: String
    field :title_id, type: String, default: ->{"#{title.parameterize}-#{release_year}"}

    def self.find_or_create(data)
      find_or_create_by data
      # find(data[:id]) || with(safe:false).create(data)
    end

    def fl_film
      @fl_film ||= Film.find_by _title_id: title_id
    end

    def set_film_id
      if fl_film
        update_attribute :film_id, fl_film.id
        fl_film.update_attributes(netflix_id: id)
      end
    end
  end
end