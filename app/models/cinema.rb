class Cinema
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  embeds_many :daily_schedules

  geocoded_by :address, :skip_index => true
  reverse_geocoded_by :coordinates

  before_create :set_coordinates


  field :coordinates, :type => Array

  def postal_code
    address['postalCode']
  end

  def find_or_create_daily_schedule(day)
    daily_schedules.find_or_create_by( day: day.to_date.to_s)
  end

  def self.find_by_tms_id(id)
    find_by(theatreId: id.to_s)
  end

  def set_coordinates
    self.coordinates = [longitude, latitude]
  end

  def longitude
    self['longitude'].to_f
  end

  def latitude
    self['latitude'].to_f
  end

  def self.cities
    @cities ||= all.map {|c| c.address['city']}.uniq
  end

  
end