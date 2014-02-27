# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::Block do
  ip_pattern '144.76.41.8' do halt 404 end
  ip_pattern '173.208.183.50' do halt 404 end
  ip_pattern '74.112.203.115' do halt 404 end
  ip_pattern '180.76.6.37' do halt 404 end
  ip_pattern '180.76.5.26' do halt 404 end
  ip_pattern '180.76.5.214' do halt 404 end
  ip_pattern '144.76.95.232' do halt 404 end
end
    
run Filmlovers::Application
