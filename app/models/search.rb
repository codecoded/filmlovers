class Search

  attr_reader :doc, :credits

  def initialize(doc)
    @doc = doc
  end

  def self.films(query, options={})
    find(query, :movie, options)
  end

  def self.persons(query, options={})
    find(query, :person, options)
  end

  def self.lists(query, options={})
    find(query, :list, options)
  end

  def self.companies(query, options={})
    find(query, :company, options)
  end

  def self.keywords(query, options={})
    find(query, :keyword, options)
  end

  def self.find(query, search_type=:movie, options={})
    SearchRepository.new(query, search_type, options ).find
  end

  def save!
    repository.save! doc
  end

  def results
    @results ||= doc['results']
  end

  def method_missing(method, args={})
    doc[method.to_s]
  end

  protected
  def repository
    SearchRepository.new query, search_type
  end
end