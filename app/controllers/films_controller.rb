require 'results_page'
class FilmsController < ApplicationController

  respond_to :html, :json

  def index
  end

  def show
  end

  def view
    render 'show'
  end

  def trailer_popup
    render partial: 'trailer_modal' 
  end

  def list_view
    render partial: 'list_view'
  end

  # def actioned
  #   results_page = Films.paged_actioned(params[:user_action], params[:order],  params[:by], params[:page].to_i, 50)
  #   @films_page = FilmsPagePresenter.new current_user, results_page, params[:user_action]
  #   render 'index'
  # end

  def summary
    @film_view = FilmPresenter.new current_user, film
    @thumbnail_size = 'w45'
    render partial: 'summary'
  end

  def coming_soon
    render_films FilmCollection.coming_soon.films, :release_date, :asc
  end

  def in_cinemas
    render_films FilmCollection.in_cinemas.films, :release_date, :desc
  end

  def popular
    render_films Film, :popularity, :desc
  end

  def users
    @users =film.actions_for(user_action).map &:user
    params[:view] = 'users'
    render 'show'
  end

  protected


  def render_films(query, order, by)
    @films ||= page_results query, order, by
    request.xhr? ? render('index', layout:nil) : render('index')
  end

  def perform_search
    # page_size = 28
    # films = Film.search(params[:query], :title, :release_date, :desc).page(page_no).per(page_size)
    # ResultsPage.new films, films.count, page_size, page_no
    TmdbFilmsSearch.new.search(params[:q] || params[:query], page_options)
  end


  def film
    @film ||= Film.fetch(params[:id])
  end

  def user_action
    params[:user_action].to_sym if params[:user_action]
  end

  helper_method :user_action, :film

end
