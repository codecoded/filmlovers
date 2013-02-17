class UserFilmsController < ApplicationController
  
  before_filter :validate_username
  skip_before_filter :validate_current_user, :except => [:update, :destroy]


  def index
    render layout:nil if request.xhr?
  end
  
  def show
    results = user_service.films_in_list(list_name)
    present(results) 
  end

  def update
    count = queue? ? user_service.queue(film) : user_service.add(film, list_name)
    render_ok count
  end

  def destroy
    count = queue? ? user_service.dequeue(film) : user_service.remove(film, list_name)
    render_ok count
  end

  protected 
  def render_ok(count)
    respond_to do |format|
      format.json  { render json: {count: count} }
    end
  end

  def validate_current_user
    @is_current_user = user.id == current_user.id
  end

  def validate_username
    redirect_to root_path unless user
  end

  def user
    if BSON::ObjectId.legal? user_id
      @user ||= User.find(user_id)
    else
      @user ||= User.find_by(username: user_id)
    end
  end


  def present(films)
    results_page =  ResultsPage.new(films)
    @films_page = FilmsPagePresenter.new current_user, results_page
    render layout:nil if request.xhr?
  end

  def user_id
    params[:user_id]
  end

  def list_name
    params[:id].to_sym
  end

  def queue?
    list_name == :queued
  end

  def film 
    Film.find params[:film_id].to_i
  end
end
