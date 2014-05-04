class FacebookAuth
  
  def self.authenticate(signed_request)
    user = User.find_by_passport Passport.from_facebook_request(signed_request)
    # validate_player(user) ? user : false
  end

  # def self.validate_player(player)
  #   return unless player
  #   token_not_expired? player
  # end

  # def self.token_not_expired?(player)
  #   player.oauth_expires_at > Time.now.utc
  # end
end