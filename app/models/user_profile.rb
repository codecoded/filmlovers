class UserProfile
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user, autobuild: true

  attr_accessible :avatar
  mount_uploader :avatar, AvatarUploader  

  field :cover_image,       type: String

end