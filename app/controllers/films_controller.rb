class FilmsController < ApplicationController

  before_filter :init_film_search

  def show
    @film_view = FilmPresenter.new current_user, Film.fetch(params[:id])
  end

  def trend
    results = Rails.cache.fetch params[:trend] do
      @tmdb_service.by_trend params[:trend], page_options
    end
    present(results, params[:trend]) and render_template
  end

  def search
    results = @tmdb_service.search params[:query], page_options
    present(results, params[:query]) and render_template
  end

  def genre
    results = Rails.cache.fetch  params[:genre_id] do
      @tmdb_service.by_genre params[:genre_id], page_options
    end
    present(results, params[:genre_id]) and render_template
  end

  protected

  def render_template
    render :index, layout:nil
  end

  def init_film_search
    @tmdb_service = TmdbFilmsSearch.new
  end

  def page_options
    params[:page] ? {page: params[:page].to_i} : {} 
  end

  def present(results_page, description='')
    @films_page = FilmsPagePresenter.new(current_user, results_page, description)
  end

end
