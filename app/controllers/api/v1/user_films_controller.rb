module Api
  module V1
    class UserFilmsController < BaseController

      before_filter :validate_user, only: [:update, :destroy]
      respond_to :json

      def index
        find_films user.films.all, :popularity
      end

      def show
        find_films user.films[user_action]
      end

      def update
        FilmUserAction.do film, user, user_action
      end

      def destroy
        FilmUserAction.undo film, user, user_action
      end

      protected 

      def validate_user
        current_user && user && (current_user.id == user.id)
      end

      def user
        @user ||= User.find(user_id)
      end

      def user_id
        params[:user_id]
      end

      def user_action
        params[:action_id].to_sym
      end

      def film 
        @film ||= Film.find params[:id]
      end


      def render_films(query)
        find_films query
        render :index
      end
      

      helper_method :user_action, :film, :user
    end
  end
end