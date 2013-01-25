class Tmdb::Search

  attr_reader :query, :data, :search_type

  def initialize(query, search_type)
    @query, @search_type = query, search_type
  end

  def method
    "search/#{search_type}"
  end

  def find(with_options={})
    @data = Tmdb::API.request method, add_options(with_options)
  end

  def add_options(optionals)
    {query: query}.merge(optionals)
  end

end