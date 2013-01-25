class SearchController < ApplicationController

  def films
    @film_search_results = present(Search.films(params[:query], page_options))
  end

  def genre
    @film_search_results = present(GenreRepository.new(params[:id]).find)
    render :films
  end

  protected

  def page_options
    params[:page] ? {page: params[:page].to_i} : {} 
  end

  def present(films)
    FilmSearchResultPresenter.new(current_user, films)
  end
end
