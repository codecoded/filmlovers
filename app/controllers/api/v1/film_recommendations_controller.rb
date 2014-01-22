module Api
  module V1
    class FilmRecommendationsController < BaseController

      def received
        # options = paging_options sort_by: :total, page_size: 10
        # @query = ActiveUserQuery.new Film.recommendations_view_for(current_user.id, :recommended), options


        if friends_view?
          @results = User.recommendations_view_for(current_user.id, state)
          render 'received_friends'
        else
          if state.to_sym == :approved
            @results = FilmRecommendation.for_friend(current_user.id).approved.view_by_film.map &:film
            render 'approved'
          else
            @results = Film.recommendations_view_for(current_user.id, state)
          end
        end
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
        @recommendations = film_recommendation_service.recommend_to selected_friends, comment
      end

      def new
      end

      def change
        film_recommendation.send params[:change_action]
        head 200
      end

      protected

      def state
        @state ||= (params[:state] || :recommended)
      end

      def friends_view?
        params[:view_by] == 'friend'
      end

      def film_recommendations
        @film_recommendations ||= current_user.recommended_films
      end

      def film_recommendation_service
        current_user.film_recommender film
      end

      def selected_friends
        friendships.where(friend_id: friend_ids)
      end

      def comment
        params[:comment]
      end

      def film_recommendation
        params[:id] ? FilmRecommendation.find(params[:id]) : film.recommendations.new(user_id: current_user.id)
      end

      def friendships
        @friendships ||= film_recommendation_service.available_friends
      end

      def film_id
        params[:film_id]
      end

      def friend_ids
        params[:friend_id]
      end

      def film
        @film ||= Film.find film_id
      end

      helper_method :friendships, :film
    end
  end
end