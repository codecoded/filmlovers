class TmdbFilmsSearch

  attr_reader :films

  def by_trend(trend, page_options={})
    fetch { Tmdb::API.films trend, page_options }
  end

  def search(query, page_options={})
    fetch { Tmdb::API.search query, page_options}
  end

  def by_genre(genre_id, page_options={})
    @genre = genre_id.is_a?(String) ? Genres.find_by_name(genre_id) : Genres.find(genre_id)
    fetch { 
      Tmdb::API.genre @genre.id , page_options.merge({include_all_movies: true, adult:true})
      } if @genre
  end

  def fetch(&block)
    tmdb_results = yield
    films = save_films(tmdb_results['results'])
    ResultsPage.from_tmdb films, tmdb_results
  end

  def save_films(results)
    return unless results
    results.map {|result| Film.with(safe:false).create result}
  end

end