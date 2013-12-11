module Api
  module V1
    class BaseController < ActionController::Base
      include PageOptions

      layout false
      respond_to :json
     
      before_filter :skip_trackable, :authenticate
      
      protected
      def authenticate
        if user = authenticate_with_http_token { |token, options| User.find_by_authentication_token token }
          @current_user = user
        end
      end

      def current_user
        @current_user
      end

      def skip_trackable
        request.env['devise.skip_trackable'] = true
      end

      helper_method :current_user
    end
  end
end
