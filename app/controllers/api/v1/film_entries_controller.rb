module Api
  module V1
    class FilmEntriesController < BaseController
      respond_to :json, :html

      before_filter :validate_current_user, only: [:update, :destroy]


      def index
        create_query user.films.actioned
      end
      
      def show
        create_query user.film_entries.includes(:film).find_by_action action_id
      end

      def update
        film_entry.set action_id
      end

      def destroy
        film_entry.unset action_id
      end


      protected 

      def validate_current_user
        redirect_to root_path unless current_user
      end


      def create_query(films)
        options = paging_options sort_by: :recent_action, without: [:recommendations, :actions], page_size: 50
        @query = ActiveUserQuery.new(films, options)
      end

      def action_id
        params[:id].to_sym
      end

      def film_entry
        @film_entry ||= current_user.film_entry_for params[:film_id]
      end

      def user
        @user ||= User.fetch(params[:user_id].to_i)
      end

      helper_method :user, :film_entry
    end
  end
end