module Api
  module V1
    class FilmActionsController < BaseController
      

      def show
        options = paging_options sort_by: :username, without: [:providers, :counters]
        @query = UserQuery.new(film_entries, options)
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

      helper_method :film_entry
    end
  end
end
