class FilmList
  include Mongoid::Document

  field :name
  field :description

  embedded_in :user

  def films
    queue.films
  end

  def queue
    @queue ||= FilmsQueue.new "user:#{user.id}:lists:#{id}"
  end
end