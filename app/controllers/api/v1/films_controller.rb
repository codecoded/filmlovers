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
        render_films FilmCollection.in_cinemas.films, :popularity
      end

      def popular
        render_films Film.popular, :popularity
      end

      def categories
      end

      def search
        render_films Film.search(params[:query])
      end

      def render_films(films, sort_order=:popularity)
        options = paging_options sort_by: sort_order, page_size: 50
        @query ||= ActiveUserQuery.new(films, options)
        render :index
      end
      
    end
  end
end
