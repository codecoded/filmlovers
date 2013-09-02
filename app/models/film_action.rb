class FilmAction
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :film_entry

  field :action
  field :facebook_id

  index({action: 1 }, { unique: true, name: "film_action_index", background: true })
  validates_inclusion_of :action, in: [:loved, :owned, :watched], message: 'only the following actions are allowed: loved, owned, watched'

  set_callback :create,   :after, :incr_film_count 
  set_callback :destroy,  :after, :decr_film_count 

  def self.actioned?(action)
    where(action: action).exists?
  end
  
  def film
    @film ||= Film.find(film_id)
  end

  def film_id
    @film_id ||= film_entry.film['_id']
  end

  def incr_film_count
    film.counters.inc(action, 1)
  end

  def decr_film_count
    film.counters.inc(action, -1)
  end

end