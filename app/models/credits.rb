class Credits

  attr_reader :data
  
  def initialize(casts_hash)
    @data = OpenStruct.new casts_hash
  end

  def profile_picture(person)
    AppConfig.image_uri_for ['w45', person['profile_path']]
  end

  def cast
    @cast||= data.cast.map {|c| Person.new c}
  end

  def crew
    @creq ||= data.crew.map {|c| Person.new c}
  end
end