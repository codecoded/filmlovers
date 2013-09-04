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


node :users do 
  @users.map do |user| 
    presenter = present(user, UserPresenter)
    {
      id: user.id,
      username: presenter.username,
      avator_uri: presenter.avatar_url,
      counters:{
        watched: presenter.counter_for(:watched),
        loved: presenter.counter_for(:loved),
        owned: presenter.counter_for(:owned)
      },
      friendship: if presenter.current_friendship
      {
        id: presenter.current_friendship.id,
        cancel: if presenter.current_friendship.requested? then api_v1_friendship_path(presenter.current_friendship) end,
        confirm: if presenter.current_friendship.received? then change_api_v1_friendship(presenter.current_friendship, :confirm) end,
        ignore: if presenter.current_friendship.received? then change_api_v1_friendship(presenter.current_friendship, :ignore) end,
        state: presenter.current_friendship.state
      }
      end
    }
  end
end

