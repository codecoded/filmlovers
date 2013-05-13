class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :confirm_friendship

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates :user,    uniqueness: {message: "you are already friends", scope: :friend}, presence: true
  validates_presence_of :friend


  state_machine :initial => :pending do

    event :confirm do
      transition [:pending, :broken] => :confirmed
    end

    event :block do
      transition :confirmed => :blocked
    end

    event :unblock do
      transition :blocked => :confirmed
    end

    event :break do
      transition :confirmed => :broken
    end    
  end


  def self.find_by_friend(user)
    where(friend: user).first
  end

  def self.befriended_by(user)
    where(user: user).first
  end

  def confirm_friendship
    # confirm!
  end
end