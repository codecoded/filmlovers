module Api
  module V1
    class FilmRecommendationsController < BaseController

      def index
      end

      def show
      end

      def create
      end

      def update
        @recommendations = UserFilmRecommendation.new(current_user, film).recommend_to_friends(friends)
      end

      def destroy
      end

      protected

      def friends
        return current_user.friendships.confirmed.map &:friend
        @friend ||= User.find(params[:friend_ids])
      end

      def film
        @film ||= Film.find params[:id]
      end

      helper_method :user_recommendations, :friends_recommmenations
    end
  end
end