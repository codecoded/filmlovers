module RemoteUnzipper
  extend self

  require 'zipruby'
  require 'fileutils'

  def download_unzip_import_file(uri)
    fetch_file URI(uri) do |zipped_file|
      unzip zipped_file do |unzipped_filename|
        yield unzipped_filename if block_given?
      end
    end    
  end

  def fetch_file(url)
    uri = URI(url)
    Net::HTTP.start(uri.host) do |http|
      Log.info "Downloading #{url}"
      file = store_zip_file(http.get(uri.path))
      yield file if block_given?
    end
  end

  def store_zip_file(response)
    tmp_file = Tempfile.new([Time.now.to_i, '.zip'], "#{Rails.root}/tmp")
    tmp_file.binmode
    tmp_file.write response.body
    tmp_file.close
    Log.info "Written temp file #{ tmp_file.path}"
    tmp_file.path
  end


  def unzip(filename)
    Zip::Archive.open(filename) do |archive|
      archive.each do |zipfile|
        path = Tempfile.new([zipfile.name,'.txt'],"#{Rails.root}/tmp").path
        open(path, 'wb') do |f|
          f << zipfile.read
        end
        Log.info "Unzipped #{zipfile.name} to #{path}"
        yield path if block_given?
      end

    end
  end

end