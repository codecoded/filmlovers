source 'https://rubygems.org'

# if RUBY_VERSION =~ /1.9/
#   Encoding.default_external = Encoding::UTF_8
#   Encoding.default_internal = Encoding::UTF_8
# end

gem 'rails'
gem 'thin'
gem 'nokogiri'
gem 'google_movies'
# Use unicorn as the app server
gem 'unicorn'

# gem 'mongo'
gem 'omniauth-facebook'#, '1.4.0'
gem 'omniauth-netflix'
gem "omniauth-google-oauth2"
gem 'omniauth-vimeo'
gem 'omniauth-twitter'

gem 'koala'
#gem 'redis'
gem 'rack-iframe'

gem 'log4r'
gem 'fb-channel-file'
#gem 'state_machine' # allow states on models
gem 'pusher'
# gem 'knockoutjs-rails' 
gem 'jquery-rails'#, '2.1.4'
# gem 'jquery-ui-rails'
gem 'compass-rails'
gem 'bson_ext'
gem 'mongo'
gem 'rest-client'
gem "mongoid"
gem 'newrelic_rpm', '3.5.6.55'
gem 'rabl'
gem "eventmachine", "~> 1.0.3"
gem 'meta-tags', :require => 'meta_tags'
gem 'gravtastic'
gem 'sitemap_generator'
gem 'devise'
gem 'figaro'
gem 'state_machine'
gem 'execjs'
gem 'simple_form'
gem 'masonry-rails'
gem 'therubyracer'  
gem 'kaminari' #for pagination
gem 'geocoder' # for postcode lookup

gem 'dalli'
gem 'memcachier'

gem 'netflix4r'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  # gem 'zurb-foundation', '~> 4.0.0'
  # gem "font-awesome-rails"

  # gem 'turbolinks'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  # gem 'turn', require: false # SR - for pretty test output 
  # gem 'minitest' # SR - test suite for benchmarks
  gem 'mocha', require: false
end

group :development, :test do
  gem 'ruby-prof' # SR - for profiling / benchmarking
  gem "awesome_print"
  gem 'better_errors'
  gem "binding_of_caller"
  gem "letter_opener"
  # gem 'rack-mini-profiler'
end



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'



# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
