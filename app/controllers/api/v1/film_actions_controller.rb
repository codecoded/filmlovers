module Api
  module V1
    class FilmActionsController < BaseController
      
      before_filter :validate_current_user, only: [:update, :destroy]

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
        @film ||= Film.find params[:film_id]
      end

      def action_id
        params[:id].to_sym
      end
    end
  end
end
