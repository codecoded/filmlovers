class Recommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :new_recommendation?
  after_create :notify

  belongs_to :user
  belongs_to :friend, :class_name => "User"
  belongs_to :recommendable, polymorphic: true

  validates_presence_of :friend
  validates_presence_of :user
  # validates :recommendable, uniqueness: {message: "this film has already been recommended", scope: [:friend, :user]}, presence: true

  index({ user: 1, friend: 1, recommendable: 1}, { unique: true, name: "recommendation_index", background: true })

  field :auto, type: Boolean, default: true

  def self.recommended?(user, friend, recommendable)
    where(user: user, friend: friend, recommendable: recommendable).exists?
  end

  private
  def new_recommendation?
    !(Recommendation.recommended?(user, friend, recommendable) or friend.film_actioned?(recommendable, :watched))
  end

  def notify
  end
end