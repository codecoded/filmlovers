class Recommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  before_create :new_recommendation?
  after_create :notify

  belongs_to :user
  belongs_to :friend, :class_name => "User"
  belongs_to :recommendable, polymorphic: true

  validates_presence_of :friend
  validates_presence_of :user
  # validates :recommendable, uniqueness: {message: "this film has already been recommended", scope: [:friend, :user]}, presence: true

  index({ user: 1, friend: 1, recommendable: 1}, { unique: true, name: "recommendation_index", background: true })

  field :auto, type: Boolean, default: true

  scope :visible, -> {where state: :visible}

  state_machine :initial => :visible do

    event :unrecommend do
      transition :visible => :deleted
    end

    event :hide do
      transition :visible => :hidden
    end

    event :show do
      transition :hidden => :visible
    end
  end

  def self.recommended?(user, friend, recommendable)
    where(user: user, friend: friend, recommendable: recommendable).exists?
  end

  def self.recent(limit=5)
    order_by(:created_at.desc).limit(limit)
  end

  def self.from_friends(user)
    where(friend: user)
  end

  private
  def new_recommendation?
    !(Recommendation.recommended?(user, friend, recommendable) or friend.film_actioned?(recommendable, :watched))
  end

  def notify
  end
end