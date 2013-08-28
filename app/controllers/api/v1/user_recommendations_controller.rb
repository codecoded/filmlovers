module Api
  module V1
    class UserRecommendationsController < BaseController

      def index
      end

      def sent
        @sent ||= user.recommendations
      end

      def received
        @received ||= Recommendation.where(friend: user)
      end

      def show
      end

      def create
      end

      def update
      end

      def destroy
        recommendation.unrecommend!
        render nothing: true
      end

      protected
      def user
        @user ||= User.find(params[:user_id])
      end

      helper_method :sent, :received
    end
  end
end