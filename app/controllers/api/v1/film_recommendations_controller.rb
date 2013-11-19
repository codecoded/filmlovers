module Api
  module V1
    class FilmRecommendationsController < BaseController

      def index
        @film_entries ||= user_films.recommended
      end

      def received
        options = paging_options sort_by: :recent, page_size: 10
        @query = UserQuery.new user_films.received_recommendations, options
        # @film_entries ||= user_films.received_recommendations
      end

      def sent
        @film_entries ||= user_films.sent_recommendations
      end

      def all_received
        @film_entries ||= user_films.all_received_recommendations
      end

      def create
        return head 400 if friend_ids.nil?
        @recommendations = film_entry.recommend_to(friendships.where(:friend_id.in => friend_ids), comment).compact
      end

      def new
      end

      def change
        film_recommendation.send params[:change_action]
        head 200
      end

      protected

      def user_films
        current_user.films
      end
      
      def film_recommendation
        params[:id] ? current_user.films.select_recommendation(params[:id]) : film_entry.recommendations.new
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