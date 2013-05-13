class FacebookChannel

  attr_reader :facebook

  def initialize(facebook_passport)
    @facebook = Facebook::UserAPI.new facebook_passport
  end

  def app_friends
    ids  = have_installed.map { |d| d['id']}
    User.where( "passports.provider" => :facebook).in("passports.uid" => ids)
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


end