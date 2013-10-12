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
    render_films FilmCollection.coming_soon.films, :earliest_release_date
  end

  def in_cinemas
    @title = 'Films in cinemas'
    render_films FilmCollection.in_cinemas.films, :release_date
  end

  def popular
    @title = 'Films'
    render_films Film.where(:release_date.lt => 1.week.from_now), :popularity
  end

  def netflix
    @title = 'Films on Netflix'
    render_films Film.by_provider(:netflix), :release_date
  end

  def rotten
    @title = 'Films on Rotten Tomatoes'
    render_films Film.by_provider(:rotten), :popularity
  end


  protected


  def render_films(query, default_sort_order)
    @sort_order = sort_by || default_sort_order
    @films ||= page_results apply_film_filters(query), @sort_order
    request.xhr? ? render('index', layout:nil) : render('index')
  end


  def film
    @film ||= Film.find(params[:id])
  end

  def user_action
    params[:action_name].to_sym if params[:action_name]
  end

  helper_method :user_action, :film

end
