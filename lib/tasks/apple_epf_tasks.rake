namespace :apple do
  
    desc "Load from local and import"
     task :import_remote, [:url] => :environment do |t, args|
      Apple::Client.import_videos_from args[:url]
    end
  

  end