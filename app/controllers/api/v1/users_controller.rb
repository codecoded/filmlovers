module Api
  module V1
    class UsersController < BaseController

      respond_to :json

      def me        
      end

      def index
        users
      end

      def show
        @user ||= user
      end
 
      def film_entries
        create_query user.film_entries.includes(:film).find_by_action action_id
      end

      protected 

      def create_query(films)
        options = paging_options sort_by: :recent_action, without: [:recommendations, :actions], page_size: 50
        @query = ActiveUserQuery.new(films, options)
      end


      def action_id
        params[:action_id].to_sym
      end

      def users
        user_query = search_query ? User.search(search_query) : User
        options = paging_options(sort_by: :username, page_size: 100)
        @query = ActiveUserQuery.new(user_query, options)

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