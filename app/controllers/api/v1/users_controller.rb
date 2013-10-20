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

        options = paging_options sort_by: :username, without: [:films_lists, :friendships, :passports, :mobile_devices], page_size: 50
        @query = UserQuery.new(user_query.filter(user_filters), options)
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