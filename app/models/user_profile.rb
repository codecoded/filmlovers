class UserProfile
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user, autobuild: true

  field :cover_image,       type: String
  field :avatar_image,      type: String

end