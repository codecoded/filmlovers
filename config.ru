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
  ip_pattern '5.255.75.47' do halt 404 end
  ip_pattern '217.79.181.76' do halt 404 end
  ip_pattern '50.28.15.25' do halt 404 end
  ip_pattern '67.20.61.120' do halt 404 end
end
    
run Filmlovers::Application
