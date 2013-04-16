class UserListsController < UsersController
  

  def index
  end
  
  def show
  end
  
  helper_method :list, :lists
  protected 

  def lists
    @lists ||= user.films_lists
  end

  def list
    @list ||= (lists.find(params[:id]) || lists.new)
  end
end
