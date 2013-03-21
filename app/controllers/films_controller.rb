require 'results_page'
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

  def summary
    @film = FilmPresenter.new current_user, Film.fetch(params[:id])
    @thumbnail_size = 'w45'
    render partial: 'summary'
  end

  def trend
    cache_key = "trend_#{params[:trend]}_page_" + (params[:page] || '')
    results = Rails.cache.fetch cache_key do
      results = @tmdb_service.by_trend params[:trend], page_options
    end
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
    cache_key = "genre_#{params[:genre_id]}_page_" + (params[:page] || '')
    results = Rails.cache.fetch cache_key do
      results = @tmdb_service.by_genre params[:genre_id], page_options
    end
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
