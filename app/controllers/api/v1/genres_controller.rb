module Api
  module V1
    class GenresController < FilmsController

      def index
      end
      
      def show
        find_films Film.elem_match(:genres => {'id'=>genre.id}), :popularity, :desc
      end

      protected

      def genre
        Genre.find_by_name params[:id]
      end

    end
  end
end