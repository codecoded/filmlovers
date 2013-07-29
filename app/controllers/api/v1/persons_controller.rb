module Api
  module V1
    class PersonsController < FilmsController

      def show
        @person_view = PersonPresenter.new current_user, Person.fetch(params[:id])
        render_template
      end
      
      protected

      def person
        @person ||= Person.fetch(params[:id])
      end

      helper_method :person

    end
  end
end