module Api
  module V1
    class MobileDevicesController < BaseController
      
      respond_to :json
      
      def create
        current_user.mobile_device_by(provider).set_token token
      end

      protected

      def provider
        params[:provider]
      end

      def token
        params[:token]
      end
    end
  end
end