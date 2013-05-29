class Recommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :notify

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  belongs_to :recommendable, polymorphic: true

  validates_presence_of :friend


  def notify
  end
end