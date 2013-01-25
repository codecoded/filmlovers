class Film

  attr_reader :doc, :credits

  FilmLists = [:watched, :loved, :unloved, :queued]

  def initialize(doc)
    @doc = doc
  end

  def self.find(id)
    FilmRepository.find id
  end
  
  def users
    @lists ||= FilmLoverLists.new("film:#{id}:users")
  end

  def credits
    @credits ||= Credits.new doc['casts']
  end

  def images
    @images = Images.new(doc['images'])
  end

  def poster(size='original')
    AppConfig.image_uri_for [size, poster_path] if doc['poster_path']
  end

  def has_poster?
    poster_path
  end

  def backdrop(size='original')
    AppConfig.image_uri_for [size, backdrop_path] if doc['backdrop_path']
  end

  def method_missing(method, args={})
    doc[method.to_s]
  end
end