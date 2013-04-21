class UserListsController < UsersController
  

  def index
  end
  
  def show
  end
  
  helper_method :list, :lists
  protected 

  # def lists
  #   @lists ||= viewing_own? ? user.films_lists : user.films_lists.viewable
  # end

  def list
    @list ||= (user.films_lists.find(params[:id]) || lists.new)
  end
end
