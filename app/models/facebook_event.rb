class FacebookEvent < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :event_type, :facebook_id

  validates_presence_of :user

  def self.events_for(type)
    where(event_type: type)
  end

  def self.recent(date=Time.now.utc)
    where("created_at > ? ", date.to_date).order('created_at desc')
  end

end
