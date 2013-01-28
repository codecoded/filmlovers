class TmdbFilmSearch

  attr_reader :search_results

  def fetch(&block)
    @search_results = Search.new yield
    save_films search_results['results']
    # Search.new search_results
  end

  def save_films(results)
    return unless results
    results.each {|result| Film.with(safe:false).create result}
  end

end