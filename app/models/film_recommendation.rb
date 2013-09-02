class FilmRecommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :film_entry  
  belongs_to  :friend, :class_name => "User"

  field :auto,      type: Boolean, default: false
  field :sent,      type: Boolean, default: true
  field :comment,   type: String

  validates :friend, uniqueness:  {message: "this friend has already been sent a recommendation", scope: [:friend]}, presence: true
  validate  :film_recommendable, on: :create

  index({ friend: 1, state: 1},   { unique: true, name: "recommendation_index", background: true })

  scope :sent, ->{where(sent: true)}
  state_machine :initial => :pending do
    event(:recommend)    { transition :pending => :recommended}
    event(:receive)      { transition :pending => :received}
    event(:unrecommend)  { transition :visible => :removed }
    event(:hide)         { transition :visible => :hidden}
    event(:show)         { transition :hidden  => :visible }
  end

  def self.recommended?(friend)
    where(friend: friend).exists?
  end

  def self.recent(limit=5)
    order_by(:created_at.desc).limit(limit)
  end

  def film
    @film ||= film_entry.fetch_film
  end

  def user
    @user ||= film_entry.fetch_user
  end

  # def self.fetch_by(friend, comment=\nil)
  #   find_by(friend: friend) || create(friend: friend, comment: comment)
  # end

  private
  def film_recommendable
    !friend.films.actioned?(film_entry.film)
  end

end