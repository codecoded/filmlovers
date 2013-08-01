class FilmUserAction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String, default: -> { to_param }
  field :action
  field :facebook_id

  belongs_to :film, validate: false
  belongs_to :user, validate: false

  index({ user: 1, action: 1 }, { unique: false, name: "film_user_action_index", background: true })

  set_callback :create,   :after, :update_film_count 
  set_callback :destroy,  :after, :update_film_count 

  def self.do(film, user, action)
    find_or_create_by(film: film, user: user, action: action)
    # film.counters.inc action, 1 
  end

  def self.undo(film, user, action)
    where(film: film, user: user, action: action).destroy
    # film.counters.inc action, -1 
  end

  def to_param
    "#{film.id}:#{user.id}:#{action}"
  end

  def self.[](action)
    where action: action
  end

  def to_s
    "film_user_action_id=#{id} #{user} #{film} action=#{action} facebook_id=#{facebook_id}"
  end

  def update_film_count
    film.counters.set action, film.actions_for(action).count
  end
end