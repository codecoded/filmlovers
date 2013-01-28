class FilmsController < ApplicationController

  before_filter :init_film_search

  def trend
    @search_service.fetch { Tmdb::API.films params[:trend], page_options}
    present params[:trend] and render :index
  end

  def search
    @search_service.fetch { Tmdb::API.search params[:query], page_options}
    present :search and render :index
  end

  def genre
    genre_id = Genres.find_by_name params[:genre_id]
    @search_service.fetch { Tmdb::API.genre genre_id.id , page_options} if genre_id
    present :genre and render :index
  end
  protected

  def init_film_search
    @search_service = TmdbFilmSearch.new
  end

  def page_options
    params[:page] ? {page: params[:page].to_i} : {} 
  end

  def present(type)
    @film_search_results = FilmSearchResultPresenter.new current_user, @search_service.search_results, type
  end

end
