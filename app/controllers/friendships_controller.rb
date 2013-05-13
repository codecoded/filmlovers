class FriendshipsController < ApplicationController

  respond_to :json, :html

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def update
    friendships.where(friend: friend).find_or_create_by.confirm!
    friend.friendships.where(friend: current_user).find_or_create_by.confirm! if !friend.friends?(current_user)  
    render layout:nil
  end

  def destroy
    friendship.break!
    friendships.befriended_by(friend).break!
    render layout:nil
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
    @friendships ||= current_user.friendships
  end

  def friendship
    @friendship ||= friendships.find_by_friend(friend)
  end

  def friend
    @friend ||= User.find_by username: params[:id]
  end

  helper_method :friendships, :friendship, :friend
end
