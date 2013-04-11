class FilmUserAction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String, default: -> { to_param }
  field :action
  field :facebook_id



  belongs_to :film, validate: false
  belongs_to :user, validate: false

  # after_create :update_film_count, :update_user_count

  def self.do(film, user, action)
    find_or_create_by(film: film, user: user, action: action)
  end

  def self.undo(film, user, action)
    where(film: film, user: user, action: action).destroy
  end

  def to_param
    "#{film.id}:#{user.id}:#{action}"
  end

  def self.[](action)
    where action: action
  end
end