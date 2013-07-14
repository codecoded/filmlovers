class DailySchedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String, default: ->{ day.to_s}
  
  scope :current, -> { where :id.gte => Time.now.to_date  }

  field :day, type: Date

  def self.todays
    find_by(_id: Time.now.utc.to_date.to_s)
  end

  embedded_in :cinema
  embeds_many :show_times, class_name: "ShowTimes"

end