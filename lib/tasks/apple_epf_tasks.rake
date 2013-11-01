namespace :apple do
  
    desc "Load from local and import"
     task :import_remote, [:url] => :environment do |t, args|
      url = args[:url]
      RemoteUnzipper.download_unzip_import_file(url) do |filename|
        AppleEpf::Parser.new(filename).process_row {|row| Apple::Movie.upsert row}
      end
    end
  

  end