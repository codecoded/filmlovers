class Genre
  include Mongoid::Document

  # field :_id, type: String, default: ->{ id }


  def self.cached
    Rails.cache.fetch 'genres' do
      all.to_a
    end 
  end

  def self.find_by_name(name)
    cached.select{ |g| g.to_param == name }.first
  end

  def to_param
    name.downcase.parameterize.underscore
  end
end