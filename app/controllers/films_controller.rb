class FilmsController < ApplicationController
  
  before_filter :validate_username

  def show
    @films = FilmPresenter.from_films user, user_service.films_in_list(list_name)
  end

  def update
    validate_current_user
    user_service.add film, list_name
    respond_to do |format|
      format.json  { render json: {response: :ok} }
    end
  end

  def destroy
    validate_current_user
    user_service.remove film, list_name
    respond_to do |format|
      format.json  { render json: {response: :ok} }
    end
  end

  def validate_current_user
    @is_current_user = user.id == current_user.id
  end

  def validate_username
    redirect_to root_path unless user
  end

  def user
    @user ||= User.where(username: params[:username]).first
  end

  def list_name
    params[:id].to_sym
  end

  def film 
    Film.find params[:film_id].to_i
  end
end
