object false

extends 'api/v1/shared/pages'

node :users do 
  @query.results.map do |user| 
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
        confirm: if presenter.current_friendship.received? then change_api_v1_friendship_path(presenter.current_friendship, :confirm) end,
        ignore: if presenter.current_friendship.received? then change_api_v1_friendship_path(presenter.current_friendship, :ignore) end,
        state: presenter.current_friendship.state
      }
      else
      {
        state: nil,
        request: api_v1_friendship_path(user.id)
      }
      end
    }
  end
end

