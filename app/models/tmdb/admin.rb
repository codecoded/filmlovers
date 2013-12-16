module Tmdb
  module Admin
    extend self

    def fetch_all(starting_id=-1)
      end_index = Tmdb::Client.films(:latest)['id']
      config = AdminConfig.instance
      config.update_attribute(:fetched_index, starting_id) if starting_id > 0

      while config.fetched_index < end_index do
        current_index = config.fetched_index 
        begin
          if film = Tmdb::Movie.fetch!(current_index)
            Log.debug "Film #{current_index} of #{end_index}: #{film.title}"
          else
             Log.debug "Film #{current_index} not saved"
            end
        rescue => msg
          Log.debug "Film Id failed: #{current_index}. #{msg}"
        end

        config.inc(:fetched_index, 1) 
      end
    end

    def update_changes(start_date=36.hours.ago, page_no=1)
      results_page = tmdb_results(start_date, page_no) 
      fetch_films(results_page)
      while results_page.more_pages? do
        results_page = fetch_films(tmdb_results(start_date, page_no+=1)) 
      end
    end

    protected
    def tmdb_results(start_date, page_no)
      results = Tmdb::Client.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no}
      ResultsPage.new results
    end

    def fetch_films(results_page)
      Log.debug "Page #{results_page.page_no} of #{results_page.total_pages}"
      index = 1
      results_page.results.each do |film_id| 
        begin
          film = Tmdb::Movie.fetch! film_id['id']
          Log.debug "Film #{index} of #{results_page.results.count}: #{film.title}"
        rescue => msg
          Log.debug "Film #{film_id} failed: #{msg}"
        end
        index+=1
      end
    end
  end
end