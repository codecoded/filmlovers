class Genres

  def self.find_by_name(name)
    lookup.find {|d| d.name.downcase == name.downcase}
  end

  def self.lookup
    @lookups ||= Rails.cache.fetch('genres') do
      Tmdb::API.genres['genres'].map {|genre| OpenStruct.new(genre)}
    end
  end
end