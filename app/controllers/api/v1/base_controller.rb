module Api
  module V1
    class BaseController < ActionController::Base

      layout false
      respond_to :json
     

      protected
      def current_user
        @current_user ||= PlayerSession.current_player(cookies)
      end

      def page_results(query, default_order, by=by)
        query.order_by([order || default_order, by]).page(page_no).per AdminConfig.instance.page_size
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

      helper_method :current_user, :page_no, :by, :order
    end
  end
end
