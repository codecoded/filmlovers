module Api
  module V1
    class UsersController < BaseController

      respond_to :json

      def index
        render :index, formats: :json
      end

      def show
        @user ||= user
      end


      protected 

      def user
        @user ||= User.find_by(username: user_id)
      end

      def user_id
        params[:user_id]
      end

      def user_action
        params[:id].to_sym
      end


      helper_method :user
    end
  end
end