class Genre
  include Mongoid::Document

  # field :_id, type: String, default: ->{ id }

  def to_param
    name
  end
end