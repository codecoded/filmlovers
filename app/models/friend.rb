class Friend
  include Mongoid::Document

  field :user_id, type: Integer

  validates_presence_of :user_id
  
  embedded_in :user
  
end