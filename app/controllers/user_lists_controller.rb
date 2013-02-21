class UserListsController < UserController
  

  def index
    @films_page = current_user.films_lists.map {|list| FilmsListPresenter.new  list}
    render layout:nil if request.xhr?
  end
  
  def new
    @films_page = FilmsListPresenter.from_queue(current_user, params[:film_ids])
    render layout:nil if request.xhr?
  end

  def show
    @films_page = FilmsListPresenter.new(films_list, params[:film_ids] ||= [])
    render layout:nil if request.xhr?
  end
  
  def create
    list = current_user.films_lists.create params[:films_list]
    list_service = UserFilmListService.new list
    list_service.set_films(params[:films]) if params[:films]
    flash[:created_message] = "Film list created"
    show_index
  end

  def destroy
    list_service.delete_list
    show_index
  end

  def update
    list_service.update! params[:films_list]
    list_service.set_films(params[:films]) if params[:films]
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
