class ShowTimes
  include Mongoid::Document
  include Mongoid::Timestamps

  field :film_id, type: Integer
  field :tms_id, type: String
  field :title, type: String
  field :rating, type: String
  field :release_date, type: Date
  field :times, type: Array

  embedded_in :daily_schedule

  def film
    @film ||= Film.find(film_id) if film_id
  end

  def program
    @program ||= TMS::Program.find tms_id
  end

end