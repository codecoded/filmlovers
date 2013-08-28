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
        @user ||= User.find(params[:id])
      end

      helper_method :user
    end
  end
end