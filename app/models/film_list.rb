class FilmList
  include Mongoid::Document

  field :name
  field :description

  belongs_to :user

  def films
    queue.films
  end

  def queue
    @queue ||= FilmsQueue.new "user:#{user.id}:lists:#{id}"
  end
end