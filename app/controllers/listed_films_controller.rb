class ListedFilmsController < ApplicationController
  
  respond_to :html, :js, :json

  before_filter :list

  layout :nil

  def update

    return film_not_found unless film

    listed_film = list.film_list_items.find_by film_id: film.id
    return film_already_added if listed_film

    @list_film = list.film_list_items.create(film_id: film.id, position: list.film_list_items.count)
    respond_with listed_film
  end

  def destroy
    # list_service.delete_list
    # redirect_to action: :index
  end

  protected

  def list
    @list ||= current_user.films_lists.find(params[:list_id])
  end

  def film
    @film = Film.fetch params[:id]
  end

  def film_not_found
    flash[:error] =  "Film not found"
    respond_with list
  end

  def film_already_added
    flash[:error] =  "Film #{film.title} already added to list '#{list.name}'"
    respond_with list
  end

end
