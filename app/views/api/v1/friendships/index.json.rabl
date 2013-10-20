object false


extends 'api/v1/shared/pages'

node :friendships do 
  @query.results.map do |friendship| 
    presenter = present(friendship.friend, UserPresenter)
    {
      id: friendship.id,
      username: presenter.username,
      avator_uri: presenter.avatar_url,
      friend_url: api_v1_user_path(friendship.friend.id),
      cancel: if friendship.requested? then api_v1_friendship_path(friendship) end,
      confirm: if friendship.received? then change_api_v1_friendship_path(friendship, :confirm) end,
      ignore: if friendship.received? then change_api_v1_friendship_path(friendship, :ignore) end,
      remove: if friendship.confirmed? then api_v1_friendship_path(friendship) end,
      state: friendship.state,
      counters:{
        watched: presenter.counter_for(:watched),
        loved: presenter.counter_for(:loved),
        owned: presenter.counter_for(:owned)
      }
    }
  end
end

