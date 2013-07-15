module API
  module V1
    class FilmsController < BaseController

      def coming_soon
        @films ||= page_results Films.coming_soon, :release_date, :asc
        render 'index_new'
      end

    end
  end
end
