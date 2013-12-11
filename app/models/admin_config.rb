class AdminConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :fetched_index, type: Integer, default: 1
  field :changes_since, type: DateTime, default: 15.days.ago
  field :page_size, type: Integer, default: 24
  field :netflix_last_import, type: DateTime

  class << self

    def instance
       @instance ||= AdminConfig.find_or_create_by(name: "GeneralConfig")
    end
    
    # def fetch_changed_movies()
    #   @tmdb_changes = Tmdb::Client.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no}
    #   results_page = ResultsPage.from_tmdb @tmdb_changes['results'], @tmdb_changes
    #   fetch_films(results_page, true)

    #   while results_page.more_pages? do
    #     tmdb_changes = Tmdb::Client.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no+=1}
    #     results_page = ResultsPage.from_tmdb @tmdb_changes['results'], @tmdb_changes
    #     fetch_films results_page, true
    #   end

    # end

    def update_counters
      FilmEntry.find_in_batches(batch_size: 5000) do |entries|
        entries.each do |entry|
          if film = Film.find_by_id(entry.film_id)
            film.update_counters
          end
        end
      end
    end

  end

end