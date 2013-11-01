module Apple
  class Client
    class << self

      def import_videos_from(url)
        RemoteUnzipper.download_unzip_import_file(url) do |filename|
          AppleEpf::Parser.new(filename).process_rows {|row| Apple::Movie.upsert row}
        end
      end

    end
  end
end