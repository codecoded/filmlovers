class FilmsList
  include Mongoid::Document

  field :name
  field :description

  validates_presence_of :name
  
  embedded_in :user

  def films
    queue.films
  end

  def queue
    @queue ||= FilmsQueue.new "user:#{user.id}:lists:#{id}"
  end
end