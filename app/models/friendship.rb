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

    event :request do
      transition [:pending] => :requested
    end

    event :receive do
      transition :pending => :received
    end

    event :ignore do
      transition :received => :ignored
    end

    event :confirm do
      transition any - :confirmed => :confirmed
    end    
  end

  def friend
    @friend ||= User.find friend_id
  end

end