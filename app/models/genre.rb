class Genre
  include Mongoid::Document

  # field :_id, type: String, default: ->{ id }


  def self.all
    ["Action", 
      "Adventure", 
      "Animation", 
      "Comedy", 
      "Crime", 
      "Disaster", 
      "Documentary", 
      "Drama", 
      "Eastern",
      "Family", 
      "Fan Film", 
      "Fantasy", 
      "Film Noir", 
      "Foreign", 
      "History",
      "Holiday", 
      "Horror", 
      "Indie", 
      "Music", 
      "Musical", 
      "Mystery", 
      "Neo-noir", 
      "Road Movie", 
      "Romance", 
      "Science Fiction", 
      "Short", 
      "Sport", 
      "Sporting Event", 
      "Sports Film", 
      "Suspense", 
      "TV movie", 
      "Thriller", 
      "War", 
      "Western"]    
  end
  
  # def self.cached
  #   # Rails.cache.fetch 'genres' do
  #   @cached||=all.to_a
  #   # end 
  # end

  # def self.find_by_name(name)
  #   cached.find{ |g| g.to_param == name }
  # end

  # def self.find_by_id(id)
  #   cached.find{ |g| g.id == id }
  # end

  # def to_param
  #   name.downcase.parameterize.underscore
  # end

  # def to_s
  #   name
  # end
end