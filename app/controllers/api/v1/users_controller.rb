module Api
  module V1
    class UsersController < BaseController

      respond_to :json

      def index
        users
      end

      def show
        @user ||= user
      end

      protected 

      def users
        user_query = search_query ? User.search(search_query) : User
        @users ||= find_films user_query.without(:films_lists), :username
      end

      def user
        @user ||= User.find(params[:id])
      end

      def search_query
        params[:query]
      end

      helper_method :users, :user
    end
  end
end