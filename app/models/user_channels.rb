class UserChannels

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def [](channel)
    self.send channel
  end

  def facebook
    return unless user.passport_for :facebook
    FacebookChannel.new user.passport_for(:facebook)
  end


end