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
    @title = 'Films coming soon' + filters_desc
    @met_title = 'Films coming soon' + filters_desc
    @meta_desc = 'Discover the latest films coming soon, and keep ahead of your friends for films to love'
    @meta_key = 'films coming soon, movies coming soon, latest films, new movies, latest releases, recommend films'
    render_films FilmCollection.coming_soon.films, :popularity
  end

  def in_cinemas
    @title ="Films in cinemas" + filters_desc
    @met_title = 'Films now showing in UK cinemas' + filters_desc
    @meta_desc = 'Found out what films are showing currently in cinemas across the UK and discover which films are currently trending to help you decide what to film to see next!'
    @meta_key = 'films in cinema, movies being screened, latest films, new movies, latest releases, most popular films showing, UK cinemas, films now playing, recommend films'
    render_films FilmCollection.in_cinemas.films, :popularity
  end

  def popular
    @title = "Films" + filters_desc
    @met_title = 'Discover films to love and recommend to friends' + filters_desc
    @meta_desc = 'Browse from over 100,000 films and find out which films are most loved, watched or even owned! Start building your own films library now!'
    @meta_key = 'popular films, films library, movie catalogue, browse films, discover films, movies, films list, movies, filmlovers, recommend films'
    render_films Film.popular, :popularity
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

  def meta_tags
    {
      title: @title,

    }
  end

  def render_films(films, default_sort_order)
    options = paging_options sort_by: default_sort_order
    # films = films.with_entries_for(current_user)
    @query ||= ActiveUserQuery.new(films.filter(film_filters), options)
    render('index')
  end


  def film
    @film ||= Film.includes(:providers).with_entries_for(current_user).find(params[:id])
  end

  def user_action
    params[:action_name].to_sym if params[:action_name]
  end

  helper_method :user_action, :film

end
