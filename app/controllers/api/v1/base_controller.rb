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

      def find_films(query, sort_by=:popularity)
        @films = page_results query, sort_by
        @films_count = @films.count
        @total_pages = (@films_count / page_size) + 1
      end


      def skip_trackable
        request.env['devise.skip_trackable'] = true
      end

      def page_results(query, default_sort_order, page_size=AdminConfig.instance.page_size)
        @order = sort_by || default_sort_order.to_s
        sort_order = sort_orders[@order]
        query.order_by(sort_order).page(page_no).per page_size
      end

      def page_size
        @page_size ||= 20
      end

      def page_no
        @page_no ||= params[:page] ? params[:page].to_i : 1
      end

      def by
        @by ||= params[:by] || :desc
      end

      def sort_by
        @sorty_by ||= params[:sort_by]
      end

      def sort_orders
        {
          'title'                 =>  [:title, :asc], 
          'recent'                =>  [:updated_at, :desc],
          'release_date'          =>  [:release_date, :desc],
          'earliest_release_date' =>  [:release_date, :asc],
          'popularity'            =>  [:popularity, :desc],
          'watched'               =>  ['counters.watched', :desc], 
          'loved'                 =>  ['counters.loved', :desc],
          'owned'                 =>  ['counters.owned', :desc] 
        }
      end
      helper_method :current_user, :page_no, :by, :order, :page_size, :sort_by
    end
  end
end
