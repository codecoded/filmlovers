class Images

  attr_reader :doc, :posters, :backdrops

  def initialize(doc)
    @doc = doc
  end

  def posters_library
    @posters ||= Posters.new posters
  end

  def backdrops
    @backdrops ||= backdrops
  end

  def poster_for(size, film)
    AppConfig.image_uri_for(original, film)
  end
end