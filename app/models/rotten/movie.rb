module Rotten
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    after_create :set_film_id

    # field :_id, type: String, default: ->{ self.TMSId }
    field :film_id, type: Integer

    def self.find_or_create(data)
      find(data['id']) || with(safe:false).create(data)
    end

  
    def imdb_id
      "tt#{self['alternate_ids']['imdb']}" if (self['alternate_ids'] and  self['alternate_ids']['imdb'])
    end


    def fl_film
      @fl_film ||= Film.find_by(imdb_id: imdb_id)
    end

    def set_film_id
      if fl_film
        update_attribute :film_id, fl_film.id
        fl_film.update_attributes(rotten_id: id)
      end
    end
  end
end