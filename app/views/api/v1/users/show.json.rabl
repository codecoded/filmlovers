object @user

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end

presenter = present(@user, UserPresenter)

node :user do 
  {
    username: presenter.username,
    counters:{
      watched: presenter.counter_for(:watched),
      loved: presenter.counter_for(:loved),
      owned: presenter.counter_for(:owned)
    },
    friendships: user.friendships.confirmed.map do |friendship|
    {
      friend_id: friendship.friend.username,
      friend_url: user_path(friendship.friend),
      avator_uri: friendship.friend.avatar.url,
      status: friendship.state
    }
    end
  }
end

