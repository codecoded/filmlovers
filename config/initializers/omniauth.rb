OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Facebook.app_id, Facebook.secret, scope:Facebook.permissions
  provider :netflix, 'rxbsfzz89y2sxgfjkcadsk48','35CWysn9sT'
  provider :google_oauth2, "5253203747.apps.googleusercontent.com", "9LkKyMMjFGZomWKuR2udVn7t"
  provider :vimeo, '2799b83d17605fec70aa8b57702e9d43835e9cc3', '1a2da2bc8914d56c535c5465798efb1a0595461e'
  provider :twitter, "dePWCZWQgQOAUpNjRN3Rg", "twED1WpB4UC62T5PXe1QvxTtNnIuX9UwohpaDTV7S4"
end