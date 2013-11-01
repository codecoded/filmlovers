module RemoteUnzipper
  extend self

  require 'zip/zip'

  def download_unzip_import_file(uri)
    fetch_file URI(uri) do |zipped_file|
      unzip zipped_file do |unzipped_filename|
        yield unzipped_filename
      end
    end    
  end

  def fetch_file(url)
    uri = URI(url)
    Net::HTTP.start(uri.host) do |http|
      Log.info "Downloading #{url}"
      yield store_zip_file(http.get(uri.path)) if block_given?
    end
  end

  def store_zip_file(response)
    tmp_file = Tempfile.new([Time.now.to_i, '.zip'])
    tmp_file.binmode
    tmp_file.write response.body
    tmp_file.close
    Log.info "Written temp file #{ tmp_file.path}"
    tmp_file.path
  end


  def unzip(filename)
    Zip::ZipFile.open(filename) do |zipfile|
      zipfile.each do |file|
        path = Tempfile.new([file.name,'.txt']).path
        Log.info "Unzipped #{filename} to #{path}"
        zipfile.extract(file.name, path) {true}
        yield path if block_given?
      end
    end
  end

end