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

  def summary
    render layout: false
  end

  def coming_soon
    render_films FilmCollection.coming_soon.films, :release_date
  end

  def in_cinemas
    render_films FilmCollection.in_cinemas.films, :earliest_release_date
  end

  def popular
    render_films Film, :popularity
  end

  def users
    @users = film.actions_for(user_action).map &:user
    params[:view] = 'users'
    render 'show'
  end

  protected


  def render_films(query, sort_order)

    @sort_order = params[:sorted_by] || sort_order
    @films ||= page_results apply_film_filters(query), sort_orders[sort_order]
    request.xhr? ? render('index', layout:nil) : render('index')
  end

  def apply_film_filters(query)
    if params[:decade]
      query = query.by_decade params[:decade]
    end

    query
  end

  def perform_search
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
