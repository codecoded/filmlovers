class ListsController < UsersController
  
  respond_to :html, :json
  def index
  end
  
  def edit
  end

  def new
    if params[:film_ids]
      list.film_list_items.new(film_id: params[:film_ids].first, position: 1)
    end 
  end

  def create
    @films_list = lists.create params[:films_list]
    flash[:created_message] = "Film list created"
    redirect_to user_lists_path current_user
  end

  def destroy
    list.delete
    redirect_to user_lists_path current_user
  end

  def update
    list.film_list_items.delete_all
    list.update_attributes! params[:films_list]
    flash[:update_message] = "Film list updated"
    redirect_to user_list_path(current_user, list)
  end

  helper_method :list, :lists, :film
  protected 

  def film
    Film.find params[:film_id]
  end

  def film_ids
    params[:film_ids] ? params[:film_ids] : []
  end
  
  def lists
    @lists ||= current_user.films_lists
  end

  def list
    if params[:id]
      @list ||= lists.find params[:id]
    else
      @list ||= lists.new
    end
  end


end
