Rails.application.config.to_prepare do
  AppConfig.setup do |config|
    config.ios_app = 'filmlovr_app'
    config.page_size = 21
    config.itunes_affiliate = '10lne2'
    config.storefront_id = 143444 #USA: 143441, UK: 143444
  end

  Geocoder.configure(:cache => $redis)
end