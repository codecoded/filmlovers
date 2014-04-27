class FilmEntriesController < ApplicationController
  
  before_filter :validate_current_user, only: [:update, :destroy]
  respond_to :json, :html

  def show
    options = paging_options sort_by: :username, without: [:providers, :counters]
    @query = UserQuery.new(film_entries, options)
  end


  def index
    find_films user.films.entries
  end
  
  # def show
  #   find_films user.films[params[:id]]
  # end

  def update
    respond_with film_entry.set action_id
  end

  def destroy
    respond_with film_entry.unset action_id
  end

  protected 

  def user
    @user ||= User.fetch(params[:user_id])
  end

  def users
    film_entries.map &:user
  end

  def film
    @film ||= Film.find(params[:film_id])
  end

  def validate_current_user
    redirect_to root_path unless current_user
  end

  def film_entry
    @film_entry ||= current_user.film_entry_for params[:film_id]
  end

  def action_id
    params[:id].to_sym
  end

  def film_entries
    @film_entries ||= film.entries.find_by_action(action_id)
  end


  helper_method :user, :users, :action_id, :film
end
