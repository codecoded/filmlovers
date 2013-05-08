namespace :tmdb do

  

  task :poll, [:page_no] => :environment do |t, args|

    @tmdb_films = Filmlovers::TmdbFilmsSearch.new

    fetch_trend :now_playing
    fetch_trend :upcoming
    fetch_trend :popular,  args[:page_no].to_i 
  end

  task :update_changes, [:start_date, :page_no] => :environment do |t, args|
    start_date = args[:start_date] ? eval(args[:start_date]) : 3.days.ago

    fetch_changed_movies start_date, args[:page_no] 
  end

  def fetch_trend(trend, page=1)

    results_page = @tmdb_films.by_trend trend, {page: page}
    fetch_films results_page

    while results_page.more_pages? do
      results_page = @tmdb_films.by_trend trend, {page: page+=1}
      fetch_films results_page
    end
    # fetch_trend(trend, page+=1) if results_page.more_pages?
  end

  def fetch_films(results_page)
    results_page.results.each do |film_id| 
      film = Film.fetch film_id.id
      Log.debug "Film: #{film.title}"
    end
  end

  def fetch_changed_movies(start_date, page_no=1)
    @tmdb_changes = Tmdb::API.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no}
    results_page = ResultsPage.from_tmdb @tmdb_changes['results'], @tmdb_changes

    results_page.results.each do |film_id| 
      begin
        film = Film.force_fetch film_id['id']
        Log.debug "Film: #{film.title}"
      rescue
         Log.debug "Film Id failed: #{film_id['id']}"
      end
    end

    fetch_changed_movies(start_date, page_no.to_i + 1) if results_page.more_pages? 
  end
end