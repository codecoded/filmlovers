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

  def self.from_facebook_request(signed_request)
    request = Koala::Facebook::OAuth.new.parse_signed_request(signed_request)
    passport = Passport.new({
        provider: :facebook,
        uid: request["user_id"],
      })
  end

  def update_from_passport(passport)
    fields = ['oauth_token', 'oauth_expires_at']
    update_attributes passport.attributes.slice(fields)
  end

  def to_s
    "{passport: {provider: #{provider}, uid: #{uid}, oauth_expires_at: #{oauth_expires_at}}}"
  end
end