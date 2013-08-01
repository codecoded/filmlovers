class FilmCounters
  include Mongoid::Document
  embedded_in :film, autobuild: true

  field :watched,     type: Integer, default: 0
  field :loved,       type: Integer, default: 0
  field :owned,       type: Integer, default: 0
  # field :favourited,  type: Integer

  def set(action, score)
    update_attribute action, score
  end

  def to_json
    {
      film_id: film._title_id,
      watched: watched,
      loved: loved,
      owned: owned
    }
  end
end