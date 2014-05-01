class UserLocation

  attr_reader :location


  def initialize(location)
    @location = location
  end

  def located?
    !location.nil? and location.latitude != 0
  end

  def apple_storefront_id
    iso3_code = CountryCode.find_by_iso2 country_code
    sf = Apple::Storefront.find_by_country_code(iso3_code)
    sf ? sf.id : AppConfig.storefront_id
  end

  def country_code
    location.data['country_code'] if located?
  end

  def to_s
    !located? ? "Location: Not found" : "Location: #{location.city}, #{location.data['country_name']} (#{country_code})}"
  end

end