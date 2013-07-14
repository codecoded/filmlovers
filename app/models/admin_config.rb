class AdminConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :fetched_index, type: Integer, default: 1
  field :changes_since, type: DateTime, default: 15.days.ago

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

    def fetch_changed_movies()
      @tmdb_changes = Tmdb::API.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no}
      results_page = ResultsPage.from_tmdb @tmdb_changes['results'], @tmdb_changes
      fetch_films(results_page, true)

      while results_page.more_pages? do
        tmdb_changes = Tmdb::API.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no+=1}
        results_page = ResultsPage.from_tmdb @tmdb_changes['results'], @tmdb_changes
        fetch_films results_page, true
      end

    end


    def update_counters
      FilmUserAction.distinct(:film_id).each do |id|
        film = Film.find id
        next unless film
        [:watched, :loved, :owned].each do |action|
          film.counters.set(action, film.actions_for(action).count)
        end
      end
    end

  end

end