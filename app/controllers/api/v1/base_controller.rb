module Api
  module V1
    class BaseController < ActionController::Base

      layout false
      respond_to :json
     
      before_filter :skip_trackable, :authenticate
      
      protected

      def authenticate
        if user = authenticate_with_http_token { |token, options| User.find_by authentication_token: token }
          @current_user = user
        end
      end

      def current_user
        @current_user
      end


      def find_films(query, sort_by=:popularity, direction=:desc)
        @films = page_results query, sort_by, direction
        @films_count = @films.count
        @total_pages = (@films_count / page_size) + 1
      end


      def skip_trackable
        request.env['devise.skip_trackable'] = true
      end

      def page_results(query, default_order, by=by)
        query.order_by([order || default_order, by]).page(page_no).per AdminConfig.instance.page_size
      end

      def page_size
        20
      end

      def page_no
        params[:page] ? params[:page].to_i : 1
      end

      def by
        params[:by] || :desc
      end

      def order
        params[:order]
      end

      helper_method :current_user, :page_no, :by, :order, :page_size
    end
  end
end
