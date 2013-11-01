class Amazon::RemoteFileLeech

  # require 'net/http'

  # AWS::S3::Base.establish_connection!({
  #   access_key_id: 'your-access-key-id',
  #   secret_access_key: 'your-secret-access-key'
  # })

  # Use the Google Logo as an example
  #
  def self.fetch_remote_file(url)
    url = URI("https://www.google.com/images/srpr/logo3w.png")

    Net::HTTP.start(url.host) do |http|
      resp = http.get(url.path)
      AWS::S3::S3Object.store(File.basename(url.path), resp.body, 'yourbucketname', access: :public_read)
    end
  end

end