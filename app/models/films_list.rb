class FilmsList
  include Mongoid::Document

  field :name
  field :description

  validates_presence_of :name
  
  embedded_in :user
  embeds_many :film_list_items

  def films
    Film.find film_ids
  end

  def film_ids
    film_list_items.distinct :film_id
  end

  def append_films(film_ids)
    film_ids.each {|id| append_film id}
  end

  def append_film(film_id)
    film_list_items.create film_id: film_id, position: film_list_items.count
  end

  def to_param
    id.to_s
  end
end

