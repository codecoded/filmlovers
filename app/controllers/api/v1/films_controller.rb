module Api
  module V1
    class FilmsController < BaseController

      respond_to :json

      def show
        @film = Film.fetch params[:id]
      end

      def coming_soon
        find_films FilmCollection.coming_soon.films
        render :index
      end

      def in_cinemas
        find_films FilmCollection.in_cinemas.films
        render :index
      end

      def categories

      end

      def search
        find_films Films.search(params[:query])
      end

      def popular
        find_films Film
      end
      
    end
  end
end
