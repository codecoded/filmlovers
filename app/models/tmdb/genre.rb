class Tmdb::Genre

  attr_reader :query, :data, :search_type


  def self.method
    "genre"
  end

  def self.list
    Tmdb::API.request "#{method}/list"
  end

  def self.films(genre_id, include_all_movies=false)
     @data = Tmdb::API.request "#{method}/#{genre_id}/movies", {include_all_movies:include_all_movies}
  end

end