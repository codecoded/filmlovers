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

      def user_location
        Rails.cache.fetch request.remote_ip, expires_in: 24.hours do 
          loc = UserLocation.new(request.location)
          Log.info loc.to_s
          loc
        end        
      rescue => msg
        Log.error "Unable to find users location. Msg: #{msg}"
      end

      def current_user
        @current_user
      end

      def skip_trackable
        request.env['devise.skip_trackable'] = true
      end

      helper_method :current_user, :user_location
    end
  end
end
