class Genre
  include Mongoid::Document

  # field :_id, type: String, default: ->{ id }


  def self.find_by_name(name)
    all.find_by { |g| g.to_param == name }
  end

  def to_param
    name.downcase.parameterize.underscore
  end
end