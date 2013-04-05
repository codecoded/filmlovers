class UserFilmsController < ApplicationController
  
  before_filter :validate_username
  skip_before_filter :validate_current_user, :except => [:update, :destroy]


  def index
    render layout:nil if request.xhr?
  end
  
  def show
    results_page = UserService.new(user).paged_list(user_action, order, by, params[:page].to_i, 70)
    @films_page = FilmsPagePresenter.new user, results_page, user_action
    render layout:nil if request.xhr?
  end

  def update
    count = queue? ? user_service.queue(film) : user_service.add(film, user_action)
    render_ok count
  end

  def destroy
    count = queue? ? user_service.dequeue(film) : user_service.remove(film, user_action)
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


  def user_id
    params[:user_id]
  end

  def user_action
    params[:id].to_sym
  end

  def queue?
    user_action == :queued
  end

  def film 
    Film.find params[:film_id].to_i
  end

  def order
    params[:order] || :release_date
  end

  def by
    params[:by] || :desc
  end


  helper_method :user, :order, :by, :user_action
end
