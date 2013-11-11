module Api
  module V1
    class FilmActionsController < BaseController
      
      before_filter :validate_current_user, only: [:update, :destroy]

      def show
        options = paging_options sort_by: :username, without: [:providers, :counters]
        @query = UserQuery.new(film_entries, options)
      end

      def update
        film_entry.do_action action_id
      end

      def destroy
        film_entry.undo_action action_id
      end

      protected 

      def validate_current_user
        redirect_to root_path unless current_user
      end

      def film_entry
        @film_entry ||= current_user.films.find_or_create(film)
      end

      def film 
        @film||=Film.find params[:film_id]
      end

      def action_id
        params[:id].to_sym
      end

      def film_entries
        @film_entries ||= film.entries.find_by_action(action_id)
      end

      helper_method :film_entry
    end
  end
end
