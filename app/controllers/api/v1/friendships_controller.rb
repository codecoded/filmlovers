module Api
  module V1
    class FriendshipsController < BaseController

      respond_to :json, :html

      def index
        @friendships = friendships.where(state: filter)
      end

      def show
      end

      def new
      end

      def edit
      end

      def update
        friendships.create(friend_id: friend.id).request! 
        head 200
      end

      def change
        friendship.send params[:change_action]
         head 200
      end

      def destroy
        friendship.friend.friendship_with(current_user).delete
        friendship.delete        
        head 200
      end

      def block
        current_user.friendships.befriended_by(friend).block!
      end

      def unblock
        current_user.friendships.befriended_by(friend).unblock!
      end

      protected

      def friendships
        current_user.friendships
      end

      def friendship
        @friendship ||= friendships.find(params[:id])
      end

      def friend
        @friend ||= User.fetch(params[:id])
      end

      def filter
        params[:filter] || :confirmed
      end

      helper_method :friendships, :friendship, :friend
    end
  end
end
