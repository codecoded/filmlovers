module Api
  module V1
    class FilmEntriesController < BaseController
      respond_to :json, :html

      before_filter :validate_current_user, only: [:update, :destroy]


      def show
        options = paging_options sort_by: sort_by || :updated_at, page_size: 50
        @query = ActiveUserQuery.new(film_entries, options)  
      end


      def index
        create_query user.films.actioned
      end
      

      def update
        film_entry.set action_id
      end

      def destroy
        film_entry.unset action_id
      end


      protected 

      def film 
        @film||=Film.find params[:film_id]
      end

      def action_id
        params[:id].to_sym
      end

      def film_entries
        @film_entries ||= film.entries.find_by_action(action_id)
      end

      def validate_current_user
        redirect_to root_path unless current_user
      end


      def action_id
        params[:id].to_sym
      end

      def film_entry
        @film_entry ||= current_user.film_entry_for params[:film_id]
      end

      def user
        @user ||= User.find(params[:user_id].to_i)
      end

      helper_method :user, :film_entry
    end
  end
end