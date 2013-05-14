source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails'#, '3.2.8'
#gem 'thin'

# Use unicorn as the app server
gem 'unicorn'

# gem 'mongo'
gem 'omniauth-facebook', '1.4.0'
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
gem 'swf_fu', '~> 2.0' # loading flash files
gem 'pusher'
gem 'knockoutjs-rails' 
gem 'jquery-rails', '2.1.4'
# gem 'jquery-ui-rails'
gem 'compass-rails'

gem 'bson_ext'
gem 'mongo'
gem 'rest-client'
gem "mongoid", "~> 3.0.0"
gem 'newrelic_rpm', '3.5.6.55'

# gem 'will_paginate', '~> 3.0.0'
gem 'rabl'
gem "eventmachine", "~> 1.0.3"
gem 'meta-tags', :require => 'meta_tags'
gem 'gravtastic'
gem 'sitemap_generator'
gem 'devise'

gem 'client_side_validations', github: 'bcardarella/client_side_validations', branch: '3-2-stable'
gem 'client_side_validations-mongoid'

gem 'state_machine'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'zurb-foundation', '< 4.0.0'
  gem "font-awesome-rails"
  # gem 'turbolinks'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'turn', require: false # SR - for pretty test output 
  gem 'minitest' # SR - test suite for benchmarks
  gem 'mocha', require: false
end

group :development, :test do
  gem 'ruby-prof' # SR - for profiling / benchmarking
  gem "awesome_print"
  gem 'better_errors'
  gem "binding_of_caller"
  # gem 'rack-mini-profiler'
end



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'



# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'
