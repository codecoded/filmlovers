class FilmSearchResultPresenter < SearchResultPresenter

  def films
    @films ||= search.results.map {|result| FilmPresenter.new(user, Film.new(result))}
  end
end