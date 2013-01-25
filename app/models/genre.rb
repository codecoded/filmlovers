class Genre

  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def self.find(id)
    GenreRepository.new(id).find
  end

  def save!
    GenreRepository.new(id).save! doc
  end

  def method_missing(method, args={})
    doc[method.to_s]
  end
end