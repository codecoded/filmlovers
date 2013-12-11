class MobileDevice < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :token, :token_expires_at, :uid

  validates_presence_of   :provider, message: 'Please enter a mobile device provider'
  validates_presence_of   :token, message: 'Please enter a mobile device token'
  
  def self.by_provider(name)
    where(provider: name.to_s).first_or_initialize
  end

  def self.registered?(provider)
    where(provider: provider.to_s).exists?
  end

  def set_token(value)
    self.token = value
    save!
  end  
end
