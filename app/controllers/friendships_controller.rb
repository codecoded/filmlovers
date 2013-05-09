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
    friendships.create! friend: friend
    render layout:nil
  end

  def destroy
    friendship.destroy
    render layout:nil
  end

  protected

  def friendships
    @friendships ||= current_user.friendships
  end

  def friendship
    @friendship ||= friendships.where(friend: friend).first
  end

  def friend
    @friend ||= User.find_by username: params[:id]
  end

  helper_method :friendships, :friendship, :friend
end
