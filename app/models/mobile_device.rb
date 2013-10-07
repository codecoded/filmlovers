class MobileDevice
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  field :provider
  field :uid
  field :token
  field :token_expires_at, type: DateTime

  validates_presence_of   :provider, message: 'Please enter a mobile device provider'
  validates_presence_of   :token, message: 'Please enter a mobile device token'
  
  def self.by_provider(name)
    find_or_initialize_by(provider: name)
  end

  def set_token(value)
    self.token = value
    save!
  end
end