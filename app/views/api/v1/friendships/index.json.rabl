object false


extends 'api/v1/shared/header'


node :pages do
  {
    :previous       => page_no > 1 ? url_for(params.merge({page: page_no-1}))  : nil,
    :next           => @total_pages > page_no ?  url_for(params.merge({page: page_no+1})) : nil,
    :page_no        => page_no,
    :total_results  => @films_count,
    :page_size      => page_size,
    :total_pages    => @total_pages,
    :order          => @order,
    :by             => by,
  }
end


node :friendships do 
  friendships.map do |friendship| 
    presenter = present(friendship.friend, UserPresenter)
    {
      id: friendship.id,
      username: presenter.username,
      avator_uri: presenter.avatar_url,
      friend_url: api_v1_user_path(friendship.friend.id),
      cancel: if friendship.requested? then api_v1_friendship_path(friendship) end,
      confirm: if friendship.received? then change_api_v1_friendship_path(friendship, :confirm) end,
      ignore: if friendship.received? then change_api_v1_friendship_path(friendship, :ignore) end,
      state: friendship.state,
      counters:{
        watched: presenter.counter_for(:watched),
        loved: presenter.counter_for(:loved),
        owned: presenter.counter_for(:owned)
      }
    }
  end
end

