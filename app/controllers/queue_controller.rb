class QueueController < ApplicationController
  
  respond_to :html,  :json

  def list
    @lists = [['Please Select...', -1]]
    @lists += current_user.films_lists.all.map { |list| [list.name, queue_to_list_path(list.id)] }
    render partial:'list_from_queue', layout:nil 
  end

  def show
    results = user_service.list_films(:queued)
    present(results) 
  end

  def update_list
    service = UserFilmListService.new(films_list)
    service.move_films_from_queue params[:film_ids]
    respond_with service
  end

  def present(films)
    @films_queue = FilmPresenter.from_films current_user, films
  end

  def films_list
    @films_list ||= user_service.films_list(params[:id])
  end

end
