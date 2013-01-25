class Tmdb::List

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def self.find(id)
    new(id).find
  end

  def method
    "list/#{id}"
  end

  def find
    Tmdb::API.request method
  end
  
end