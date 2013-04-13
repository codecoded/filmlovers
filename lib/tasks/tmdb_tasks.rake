namespace :tmdb do

  

  task :poll, [:page_no] => :environment do |t, args|

    @tmdb_films = Filmlovers::TmdbFilmsSearch.new

    fetch_trend :now_playing
    fetch_trend :upcoming
    fetch_trend :popular,  args[:page_no] 
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
    timestamp = Time.now 
    results_page.results.each do |film_id| 
      film = Film.fetch film_id.id
      Log.debug "Film: #{film.title}"
    end

  end

end