class Images

  attr_reader :doc, :posters, :backdrops

  def initialize(doc)
    @doc = doc
  end

  def posters
    @posters ||= Posters.new doc['posters']
  end

  def backdrops
    @backdrops ||= doc['backdrops']
  end

  def poster_for(size, film)
    AppConfig.image_uri_for(['original', film])
  end
end