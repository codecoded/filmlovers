class FriendshipObserver < ActiveModel::Observer


  def after_request(friendship, transition)
    friendship.friend.friendships.create(friend_id: friendship.user.id).receive
    push_ios_notification friendship
  end

  def after_receive(friendship, transition)
    Log.debug "#{friendship.user.username} received friend request from #{friendship.friend.username}"
  end

  def after_confirm(friendship, transition)
    Log.debug "#{friendship.user.username} friend request confirmed with #{friendship.friend.username}"
    requesting_friendship = friendship.friend.friendship_with(friendship.user)
    return if !requesting_friendship.confirm #f !friends_friendship.confirmed?
    requesting_friendship.user.notifier.toast "#{friendship.user.username} has accepted your friend request"
  end


  def push_ios_notification(friendship)
    Thread.new do
      Log.debug "Trying to send iOS notification for friendship request: #{friendship.id}"
      friendship.friend.notifier.push_to_mobile "You have a friend request from #{friendship.user.username}!"   
    end
  end

end