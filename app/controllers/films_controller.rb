require 'results_page'
class FilmsController < ApplicationController

  before_filter :init_film_search
  # respond_to :json, :html

  def index
    render_template
  end

  def show
    @film_view = FilmPresenter.new current_user, film
    render_template
  end

  def summary
    @film_view = FilmPresenter.new current_user, film
    @thumbnail_size = 'w45'
    render partial: 'summary'
  end

  def search
    results = @tmdb_service.search params[:query], page_options
    present(results, params[:query]) and render_template :index
  end

  def quick_search
    results = @tmdb_service.search params[:q]
    present(results, params[:q])
  end

  def users
    @users = User.find film.users[user_action].members
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

  def film
    @film ||= Film.fetch(params[:id])
  end

  def user_action
    params[:user_action].to_sym
  end

  helper_method :user_action, :film

end
