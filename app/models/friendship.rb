class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  field :friend_id, type: String

  validates :user,    uniqueness: {message: "you are already friends", scope: :friend}, presence: true
  validates_presence_of :friend

  index({ user: 1, friend: 1}, { unique: true, name: "friendship_index", background: true })

  scope :confirmed, -> {where state: :confirmed}
  scope :received, -> {where state: :received}

  state_machine :initial => :pending do
    event(:request) { transition :pending => :requested }
    event(:receive) { transition :pending => :received }
    event(:ignore)  { transition :received => :ignored }
    event(:confirm) { transition any - :confirmed => :confirmed }
  end

  def friend
    @friend ||= User.find friend_id
  end

  def self.auto_friend(user, friend)
    return if user.friendship_with friend
    user.friendships.create(friend_id: friend.id, state: :confirmed)
    friend.friendships.create(friend_id: user.id, state: :confirmed)
  end
end