class Credits

  attr_reader :data
  
  def initialize(casts_hash)
    @data = OpenStruct.new casts_hash
  end

  def cast
    data.cast
  end

  def crew
    data.crew
  end
end