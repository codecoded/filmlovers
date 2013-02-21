class QueueController < UserController
  

  def list
    @lists = [['Please Select...', -1]]
    @lists += current_user.films_lists.all.map { |list| [list.name, user_list_path(current_user, list.id)] }
    render partial:'list_from_queue', layout:nil 
  end

  def show
    results = user_service.films_in_list(:queued)
    present(results) 
  end

  def update_list
    list = current_user.films_list(params)
    service = UserFilmListService.new(list)
    service.copy_films_from_queue params[:films_ids]
  end

  def present(films)
    @films_queue = FilmPresenter.from_films current_user, films
  end

end
