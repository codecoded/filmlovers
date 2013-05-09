class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates :user,    uniqueness: {message: "you are already friends", scope: :friend}, presence: true
  validates_presence_of :friend
end