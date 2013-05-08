class TmdbFilmsSearch

  attr_reader :films

  def by_trend(trend, page_options={})
    fetch { Tmdb::API.films trend, page_options }
  end

  def search(query, page_options={})
    fetch { Tmdb::API.search query, page_options}
  end

  def by_genre(genre_id, page_options={})
    fetch { Tmdb::API.genre genre_id, page_options.merge({include_all_movies: true, include_adult: false}) } 
  end

  def fetch(&block)
    tmdb_results = yield
    films = save_films(tmdb_results['results'].compact)
    ResultsPage.from_tmdb films, tmdb_results
  end

  def save_films(results)
    return unless results
    results.reject{|f| f['release_date'].empty?}.map{|result| Film.with(safe:false).create result}
  end

end