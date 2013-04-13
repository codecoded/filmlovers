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

  def view
    render 'show'
  end

  def actioned
    results_page = Films.paged_actioned(params[:user_action], params[:order],  params[:by], params[:page].to_i, 50)
    @films_page = FilmsPagePresenter.new current_user, results_page, params[:user_action]
    render 'index'
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
    @users =film.actions_for(user_action).map &:user
    params[:view] = 'users'
    render 'show'
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
