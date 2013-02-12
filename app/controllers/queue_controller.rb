class QueueController < UserController
  

  def list
    @lists = current_user.films_lists.all.map { |list| [list.name, list.id] }
    render partial:"scripts/modal", locals:{html_partial: 'list_from_queue'}, layout:nil 
  end

  def show
    results = user_service.films_in_list(:queued)
    present(results) 
  end

  def present(films)
    @films_queue = FilmPresenter.from_films current_user, films
  end

end
