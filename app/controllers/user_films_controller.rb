class UserFilmsController < ApplicationController
  
  before_filter :validate_username
  after_filter :publish_story, only: [:update]
  # after_filter :delete_story, only: [:destroy]
  skip_before_filter :validate_current_user, :except => [:update, :destroy]


  def index
    render layout:nil if request.xhr?
  end
  
  def show
    results_page = UserService.new(user).paged_list(user_action, order, by, params[:page].to_i, 50)
    @films_page = FilmsPagePresenter.new current_user, results_page, user_action
    render layout:nil if request.xhr?
  end

  def update
    count = user_service.add(film, user_action)
    render_ok count
  end

  def destroy
    count = user_service.remove(film, user_action)
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

  def film 
    Film.find params[:film_id].to_i
  end

  def order
    params[:order] || :release_date
  end

  def by
    params[:by] || :desc
  end

  def publish_story
    action = case user_action
              when :loved; "video.watches"
              when :watched;  "#{Facebook::namespace}:love"
              else; nil
            end
    return unless action and facebook_passport
    Thread.new do
      Facebook::UserAPI.new(facebook_passport).publish_story action, :movie, film_url(film)
    end
    rescue
      Log.debug 'failed to publish story'
  end


  def delete_story
  end

  def facebook_passport
    current_user.passport_for(:facebook)
  end

  helper_method :user, :order, :by, :user_action
end
