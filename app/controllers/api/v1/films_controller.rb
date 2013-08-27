module Api
  module V1
    class FilmsController < BaseController

      respond_to :json

      def show
        @film = Film.find params[:id]
      end

      def coming_soon
        render_films FilmCollection.coming_soon.films, :earliest_release_date
      end

      def in_cinemas
        render_films FilmCollection.in_cinemas.films, :release_date
      end

      def popular
        render_films Film
      end

      def categories
      end

      def search
        find_films Film.search(params[:query])
      end

      def render_films(query, sort_order=:popularity)
        find_films query.without('details.similar_movies', :providers), sort_order
        render :index
      end
      
    end
  end
end
