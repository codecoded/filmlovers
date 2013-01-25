OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Facebook.app_id, Facebook.secret, scope:Facebook.permissions, display: 'popup'
end