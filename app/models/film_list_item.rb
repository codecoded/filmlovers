class FilmListItem
  include Mongoid::Document

  field :film_id, type: Integer
  field :position, type: Integer

  validates_presence_of :film_id
  
  embedded_in :films_list
  
end