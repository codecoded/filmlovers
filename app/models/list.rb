class List
  include Mongoid::Document

  field :_id, type: String, default: ->{ id }

  attr_reader :doc

end