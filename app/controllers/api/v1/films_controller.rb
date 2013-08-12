module Api
  module V1
    class FilmsController < BaseController

      respond_to :json

      def show
        @film = Film.fetch params[:id]
      end

      def coming_soon
        render_films FilmCollection.coming_soon.films
      end

      def in_cinemas
        render_films FilmCollection.in_cinemas.films
      end

      def popular
        render_films Film
      end

      def categories
      end

      def search
        find_films Films.search(params[:query])
      end


      def render_films(query)
          find_films query
          render :index
      end
      
    end
  end
end
