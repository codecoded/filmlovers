module Api
  module V1
    class FilmRecommendationsController < BaseController

      def index
        @film_entries ||= current_user.films.recommended
      end

      def create
        return head 400 if friend_ids.nil?
        @recommendations = film_entry.recommend_to(friendships.where(:friend_id.in => friend_ids), comment).compact
      end

      def new
      end

      protected

      def film_recommendation
        params[:id] ? film_entry.find_by(recommendations: params[:id]) : film_entry.recommendations.new
      end

      def friendships
        @friendships ||= film_entry.new_recommendation_friends
      end

      def film_entry
        @film_entry ||= current_user.films.find_or_create(film)
      end

      def friend_ids
        params[:friend_id]
      end

      def comment
        params[:comment]
      end

      def film
        @film ||= Film.find params[:film_id]
      end

      helper_method :friendships, :film
    end
  end
end