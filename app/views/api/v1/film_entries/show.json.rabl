object @query

extends 'api/v1/shared/pages'

node :users do 
  @query.results.map do |film_entry| 
    presenter = present(film_entry.user, UserPresenter)
    {
      id: film_entry.user_id,
      username: presenter.username,
      avator_uri: presenter.avatar_url,
      counters:{
        watched: presenter.counter_for(:watched),
        loved: presenter.counter_for(:loved),
        owned: presenter.counter_for(:owned)
      },
      friendship: if presenter.current_friendship
      {
        state: presenter.current_friendship.state
      }
      else
      {
        state: nil
      }
      end
    }
  end
end
