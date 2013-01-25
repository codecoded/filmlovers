class ListsController < ApplicationController
  
  def show
    @films = FilmPresenter.from_films user_service.films_in_list(list_name)
  end

  def update
    user_service.add film, list_name
    respond_to do |format|
      format.json  { render json: {response: :ok} }
    end
  end

  def destroy
    user_service.remove film, list_name
    respond_to do |format|
      format.json  { render json: {response: :ok} }
    end
  end

  def list_name
    params[:id].to_sym
  end

  def film
    Film.find params[:film_id]
  end
end
