module Api
  module V1
    class FilmEntriesController < BaseController
      respond_to :json, :html

      def index
        create_query user.films.actioned
      end
      
      def show
        create_query user.films[params[:id]]
      end

      protected 

      def create_query(films)
        options = paging_options sort_by: :recent_action, without: [:recommendations, :actions], page_size: 50
        @query = UserQuery.new(films, options)
      end

      def user
        @user ||= User.fetch(params[:user_id])
      end

      helper_method :user
    end
  end
end