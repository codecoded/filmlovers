namespace :notifications do


  task :push_apns => :environment do 
    Rapns.push
  end

end