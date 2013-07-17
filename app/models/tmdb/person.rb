class Tmdb::Person 

  attr_reader :id, :data

  def initialize(id)
    @id = id
  end

  def self.find(id)
    new(id).find
  end

  def find(with_attributes=[:all])
    @data = Tmdb::Client.request method, append_to_response(with_attributes)
  end

  def get(options={})
     @data = Tmdb::Client.request method, options
  end

  def method
    "person/#{id}"
  end

  def append_to_response(movie_methods)
    return {} if movie_methods.empty?
    methods = (movie_methods.member? :all) ? append_all : movie_methods
    {append_to_response: methods.join(',')}
  end

  def append_all
    [:credits]
  end 

end