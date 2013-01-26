class Genre
  include Mongoid::Document

  field :_id, type: String, default: ->{ id }


  def self.fetch(id)
    GenreRepository.new(id).find
  end

end