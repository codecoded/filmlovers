require 'results_page'
class FilmsController < ApplicationController

  respond_to :html, :json

  def index
    render_films Film, :popularity
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
    @title = 'Films coming soon'
    render_films FilmCollection.coming_soon.films, :release_date
  end

  def in_cinemas
    @title = 'Films in cinemas'
    render_films FilmCollection.in_cinemas.films, :earliest_release_date
  end

  def popular
    @title = 'Films'
    render_films Film, :popularity
  end

  def users
    @users = film.actions_for(user_action).map &:user
    params[:view] = 'users'
    render 'show'
  end

  protected


  def render_films(query, default_sort_order)
    @sort_order = sort_by || default_sort_order
    @films ||= page_results apply_film_filters(query), @sort_order
    request.xhr? ? render('index', layout:nil) : render('index')
  end

  def apply_film_filters(query)
    query = query.by_decade params[:decade] if params[:decade]
    query = query.by_genres genre.name if genre

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
