class UserListsController < UserController
  

  def index
    @films_page = current_user.films_lists.map {|list| FilmsListPresenter.new current_user, list}
    render layout:nil if request.xhr?
  end
  
  def new
    films_from_queue = FilmPresenter.from_films(current_user, Film.find(params[:film_ids])) if params[:film_ids]
    @films_page = FilmsListPresenter.new(current_user, FilmsList.new, films_from_queue)
    render layout:nil if request.xhr?
  end

  def create
    list = current_user.films_lists.create params[:films_list]
    list_service = UserFilmListService.new list
    list_service.copy_films_from_queue(params[:films]) if params[:films]
    flash[:created_message] = "Film list created"
    show_index
  end

  def show
    @films_page = FilmsListPresenter.new(current_user, films_list)
    render layout:nil if request.xhr?
  end

  def destroy
    films_list.queue.set.delete
    films_list.delete
    show_index
  end

  def update
    list_service.update! params[:films_list]
    list_service.copy_films_from_queue(params[:films]) if params[:films]
    flash[:update_message] = "Film list updated"
    show_index
  end

  def show_index
    redirect_to action: 'index',  :status => 303
  end
 
  def films_list
    @film_list ||= user_service.films_list(params[:id])
  end

  def list_service
    @list_service = UserFilmListService.new films_list
  end
end
