class FacebookChannel
  extend Forwardable
  def_delegators :facebook, :notifications

  attr_reader :facebook, :user

  def initialize(facebook_passport)
    @user = facebook_passport.user
    @facebook = Facebook::UserAPI.new facebook_passport
  end

  def app_friends
    ids  = have_installed.map { |d| d['id']}
    user_ids = Passport.where("provider = 'facebook' and uid in (?)", ids ).pluck :user_id
    User.where(id: user_ids)
  end

  def registered_friends
    ids  = all.map { |d| d['id']}
    user_ids = Passport.where("provider = 'facebook' and uid in (?)", ids ).pluck :user_id
    User.where(id: user_ids)
    # User.where( "passports.provider" => :facebook).in("passports.uid" => ids)
  end

  def all
    @friends ||= facebook.friends('name, installed')
  end

  def have_installed
    all.select {|f| f['installed']}
  end

  def have_not_installed
    all - have_installed
  end


  def create_friends_in_app
    registered_friends.each do |friend|
      next if user.friendship_with friend
      Friendship.auto_friend(user, friend)
    end
  end

  def exchange_token
    new_token = facebook.exchange_token
    passport = facebook.user
    passport.oauth_token = new_token
    passport.oauth_expires_at = 60.days.from_now
    passport.save!
    Log.info "User '#{user.username}' token exchanged"     
    passport   
  rescue => msg
    Log.error "FacebookChannel:exchange_token --- User Id=#{user.id}, Msg: #{msg}"
  end

end