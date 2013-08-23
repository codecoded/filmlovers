class QueueController < ApplicationController
  
  respond_to :html,  :json

  def list
    @lists = [['Please Select...', -1]]
    @lists += current_user.films_lists.all.map { |list| [list.name, list_film_path(list.to_param, params[:film_ids])] }
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

  def film
    @film ||= Film.find(params[:film_ids])
  end
  helper_method :film
end
