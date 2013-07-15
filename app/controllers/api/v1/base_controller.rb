module API
  module V1
    class BaseController < ActionController::Base

      layout false
      respond_to :json
      helper_method :current_player

      protected
      def current_user
        @current_player ||= PlayerSession.current_player(cookies)
      end

      def page_results(query, default_order, by=by)
        query.order_by([order || default_order, by]).page(page_no).per AppConfig.page_size
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

    end
  end
end
