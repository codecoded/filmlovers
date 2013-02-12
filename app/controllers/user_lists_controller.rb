class UserListsController < UserController
  

  def index
    @films_lists_presenters = current_user.films_lists.map {|list| FilmsListPresenter.new current_user, list}
  end
  
  def new
    films_from_queue = FilmPresenter.from_films(current_user, Film.find(params[:film_ids])) if params[:film_ids]
    @presenter = FilmsListPresenter.new(user, FilmsList.new, films_from_queue)
    render :action => "show"
  end

  def create
    current_user.films_lists.create params[:films_list]
    Log.info "user #{current_user} created a new list, #{params}#"
    flash[:created_message] = "Film list created"
    redirect_to action: 'index'
  end

  def show
    @presenter = FilmsListPresenter.new(user, user_service.films_list(params[:id]))
  end

  def update
    list = user_service.films_list(params[:id])
    list.update_attributes! params[:films_list]  
    flash[:update_message] = "Film list updated"
    redirect_to action: 'index'
  end
 
end
