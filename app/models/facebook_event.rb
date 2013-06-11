class FacebookEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  validates_presence_of :user

  index({ user: 1, event_type: 1}, { unique: false, name: "facebook_event_index", background: true })

  field :facebook_id, type: String
  field :event_type, type: String
  field :content, type: String

  def self.events_for(type)
    where(event_type: type)
  end

  def self.recent(date=Time.now.utc)
    where(:created_at.gte => date.to_date).order_by(:created_at.desc)
  end

end