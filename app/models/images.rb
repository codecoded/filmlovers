class Images

  attr_reader :doc, :posters, :backdrops

  def initialize(doc)
    @doc = OpenStruct.new doc
  end

  def posters
    @posters ||= doc.posters
  end

  def backdrops
    @backdrops ||= doc.backdrops
  end

  def poster_for(size, film)
    AppConfig.image_uri_for(original, film)
  end
end