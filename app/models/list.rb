class List

  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def self.find(id)
    ListRepository.new(id).find
  end

  def save!
    ListRepository.new(id).save! doc
  end

  def method_missing(method, args={})
    doc[method.to_s]
  end
end