class Genre
  include Mongoid::Document

  # field :_id, type: String, default: ->{ id }


  def self.cached
    Rails.cache.fetch 'genres' do
      all.to_a
    end 
  end

  def self.find_by_name(name)
    cached.find{ |g| g.to_param == name }
  end

  def self.find_by_id(id)
    cached.find{ |g| g.id == id }
  end

  def to_param
    name.downcase.parameterize.underscore
  end

  def to_s
    name
  end
end