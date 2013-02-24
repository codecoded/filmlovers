class FilmsController < ApplicationController

  before_filter :init_film_search
  # respond_to :json, :html

  def index
    render_template
  end

  def show
    @film_view = FilmPresenter.new current_user, Film.fetch(params[:id])
    @film = @film_view
    render_template
  end

  def trend
    # results = Rails.cache.fetch params[:trend] do
     results =  @tmdb_service.by_trend params[:trend], page_options
    # end
    present(results, params[:trend]) and render_template :index
  end

  def search
    results = @tmdb_service.search params[:query], page_options
    present(results, params[:query]) and render_template :index
  end

  def quick_search
    results = @tmdb_service.search params[:q]
    present(results, params[:q])
  end

  def genre
    # results = Rails.cache.fetch  params[:genre_id] do
    results =   @tmdb_service.by_genre params[:genre_id], page_options
    # end
    present(results, params[:genre_id]) and render_template :index
  end

  protected

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
