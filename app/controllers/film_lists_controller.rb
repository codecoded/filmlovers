class FilmListsController < UsersController
  
  respond_to :html, :js, :json

  before_filter :list

  layout :nil

  def create
    add_film
  end

  def new
    @index = list.film_list_items.count+1
    list.film_list_items.new(film_id: film.id, position: @index)
  end

  def update
    return film_not_found unless film
    listed_film = list.film_list_items.find_by film_id: film.id
    return film_already_added if listed_film
    @list_film = add_film
    respond_with listed_film
  end

  def destroy
    # list_service.delete_list
    # redirect_to action: :index
  end

  helper_method :film, :list
  protected

  def add_film
    @index = list.film_list_items.count+1
    list.film_list_items.create(film_id: film.id, position: @index)
    flash[:notice] =  "Film #{film.title} added"
  end

  def list
    @list ||= current_user.films_lists.find(params[:list_id]) || current_user.films_lists.new
  end

  def film
    @film ||= Film.fetch params[:id]
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
