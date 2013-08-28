module Api
  module V1
    class FilmRecommendationsController < BaseController


      def create
      end

      def update
        @recommendations = UserFilmRecommendation.new(current_user, film).recommend_to_friends(friends)
      end

      def destroy
      end

      protected

      def friends
        @friends ||= User.find(params[:friend_id])
      end

      def film
        @film ||= Film.find params[:id]
      end

      def user_recommendations
        @user_recommendations ||= current_user.recommendations.order_by(:created_at.desc).visible
      end

      def friends_recommmenations
        @friends_recommmenations ||= current_user.recommended.unwatched
      end
  
      helper_method :user_recommendations, :friends_recommmenations
    end
  end
end