require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  attr_reader :user, :friend
  def setup
    @user = users(:sky)
    @friend = users(:ju)
  end

  
  test 'confirming a friend request notifies the user' do
    user.notifier.expects(:message) 
    request_friendship
    friends_friendhsip.confirm
  end

  def request_friendship
     user.friendships.create(friend_id: friend).request
  end

  def friends_friendhsip
    friend.friendship_with(user)
  end

end