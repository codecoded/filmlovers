module Api
  module V1
    class FilmsController < BaseController

      def coming_soon
        find_films Films.coming_soon
      end

      def in_cinemas
        find_films Films.in_cinemas
      end

      protected

      def find_films(query)
        @films = page_results query, :popularity, :asc
        @films_count = @films.count
        @total_pages = (@films_count / AdminConfig.instance.page_size) + 1
        render :index, formats: :json
      end

    end
  end
end
