class FilmEntriesController < ApplicationController
  
  respond_to :json, :html

  def index
    find_films user.films.entries
  end
  
  def show
    find_films user.films[params[:id]]
  end

  protected 

  def user
    @user ||= User.fetch(params[:user_id])
  end

  helper_method :user
end
