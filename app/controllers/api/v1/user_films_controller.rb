module Api
  module V1
    class UserFilmsController < BaseController

      before_filter :validate_user
      respond_to :json

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
        params[:id].to_sym
      end

      def film 
        @film ||= Film.find_by _title_id: params[:film_id]
      end

      helper_method :user_action, :film
    end
  end
end