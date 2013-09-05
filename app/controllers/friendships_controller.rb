class FriendshipsController < ApplicationController

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
    render partial: "friendships/#{friendship.state}"
  end

  def change
    friendship.send params[:change_action]
    render partial: "friendships/#{friendship.state}"
  end

  def destroy
    friendship.friend.friendship_with(current_user).delete
    friendship.delete  
    render partial: "friendships/pending"
  end

  def block
    current_user.friendships.befriended_by(friend).block!
  end

  def unblock
    current_user.friendships.befriended_by(friend).unblock!
  end

  # def break
  #   current_user.friendships
  # end

  protected

  def friendships
    current_user.friendships
  end

  def friendship
    @friendship ||= friendships.find_by(friend_id: friend.id)
  end

  def friend
    @friend ||= User.fetch params[:id]
  end

  def filter
    params[:filter] || :confirmed
  end

  helper_method :friendships, :friendship, :friend
end
