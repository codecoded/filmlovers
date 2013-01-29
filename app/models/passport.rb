class Passport
  include Mongoid::Document

  field :provider
  field :uid
  field :oauth_token
  field :oauth_expires_at, type: DateTime

  embedded_in :user


  def self.from_omniauth(auth)
    passport = Passport.new(
      {
        provider: auth[:provider],
        uid: auth[:uid],
        oauth_token: auth.credentials.token,
        oauth_expires_at: (Time.at(auth.credentials.expires_at) if auth.credentials.expires_at)
      })
  end

  def update_from_omniauth(auth)
    update_attributes(
      {
        oauth_token: auth.credentials.token,
        oauth_expires_at: (Time.at(auth.credentials.expires_at) if auth.credentials.expires_at)
      })
  end
end