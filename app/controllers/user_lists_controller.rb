class UserListsController < UserController
  
  before_filter :films_list, except: [:index, :new, :create, :show]

  def index
    @films_list = user.films_lists
    @films_count = AppSettings::PREVIEW_LIMIT
    @thumbnail_size = 'w90'
    render_template
  end
  
  def edit
    @thumbnail_size = 'w92'
    render_template
  end

  def new
    @films_list = user.films_lists.new
    render_template
  end

  def show
    @films_list = UserService.new(user).films_list(params[:id])
    @thumbnail_size = 'w92'
    render_template
  end
  
  def create
    @films_list = current_user.films_lists.create params[:films_list]

    flash[:created_message] = "Film list created"
    respond_to do |format|
      format.json {render 'show'}
    end
  end

  def destroy
    list_service.delete_list
  end

  def update
    list_service.update! params[:films_list]
    flash[:update_message] = "Film list updated"
    render_template :show
  end

  protected 
  def film_ids
    params[:film_ids] ? params[:film_ids] : []
  end

  def show_index
    redirect_to action: 'index',  :status => 303
  end
 
  def films_list
    @films_list ||= user_service.films_list(params[:id])
  end

  def list_service
    @list_service = UserFilmListService.new films_list
  end
end
