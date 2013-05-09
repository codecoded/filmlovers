class AdminConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :fetched_index, type: Integer, default: 1

  class << self

    def instance
       @instance ||= AdminConfig.find_or_create_by(name: "GeneralConfig")
    end


    def fetch_all
      end_index = Tmdb::API.films(:latest)['id']

      while instance.fetched_index < end_index do
        current_index = instance.fetched_index 
        begin
          film = Film.fetch current_index
          Log.debug "Film #{current_index} of #{end_index}: #{film.title}"
        rescue
          Log.debug "Film Id failed: #{current_index}"
        end

        instance.inc(:fetched_index, 1) 
      end
    end

  end

end