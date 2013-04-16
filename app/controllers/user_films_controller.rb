class UserFilmsController < ApplicationController
  
  before_filter :validate_username
  after_filter :publish_story, only: [:update]
  # after_filter :delete_story, only: [:destroy]
  skip_before_filter :validate_current_user, :except => [:update, :destroy]

  respond_to :json, :html

  def index
    render layout:nil if request.xhr?
  end
  
  def show
    results_page = UserService.new(user).paged_list(user_action, order, by, params[:page].to_i, 50)
    @films_page = FilmsPagePresenter.new current_user, results_page, user_action
    render layout:nil if request.xhr?
  end

  def update
    @film_user_action = FilmUserAction.do film, user, user_action
    respond_with @film_user_action
  end

  def destroy
    respond_with FilmUserAction.undo film, user, user_action
  end

  protected 

  def film_user_action
    FilmUserAction.find_or_initialize_by film: film, user: user, action: user_action
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

    fb_action = case user_action
              when :loved; "#{Facebook::namespace}:love"
              when :watched;  "video.watches"
              else; nil
            end
    return unless fb_action and facebook_passport
    Thread.new do
      fb_id = Facebook::UserAPI.new(facebook_passport).publish_story(fb_action, :movie, film_url(film))
      @film_user_action.update_attributes!(facebook_id:fb_id)
      Log.info "#{film.title} published to facebook as #{user_action} by #{current_user.name}"
    end

  end


  def delete_story
  end

  def facebook_passport
    current_user.passport_for(:facebook)
  end

  helper_method :user, :order, :by, :user_action
end
