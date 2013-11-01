module Api
  module V1
    class PersonsController < BaseController

      def show
        @presenter = PersonPresenter.new Person.fetch(params[:id]), Person
      end
      
      protected

      def person
        @person ||= Person.fetch(params[:id])
      end

      helper_method :person

    end
  end
end