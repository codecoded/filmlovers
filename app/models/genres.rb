class Genres

  def self.find_by_name(name)
    lookup.find {|d| d.name.downcase.parameterize.underscore == name.downcase}
  end

  def self.find(id)
    lookup.find {|d| d.id == id}
  end

  def self.lookup
    @lookups ||= Rails.cache.fetch('genres') do
      Tmdb::Client.genres['genres'].map {|genre| OpenStruct.new(genre)}
    end
  end
end