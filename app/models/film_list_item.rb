class FilmListItem
  include Mongoid::Document

  field :film_id, type: Integer
  field :position, type: Integer

  belongs_to :film, validate: false
  validates_presence_of :film_id
  
  embedded_in :films_list
  
end