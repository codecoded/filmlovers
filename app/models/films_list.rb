class FilmsList
  include Mongoid::Document

  field :name
  field :description

  validates_presence_of :name
  
  embedded_in :user

  def films
    queue.films.map {|film_id| Film.find(film_id.to_i)}
  end

  def film_ids
    queue.films.map &:to_i
  end

  def queue
    @queue ||= FilmsQueue.new "user:#{user.id}:lists:#{id}"
  end
end