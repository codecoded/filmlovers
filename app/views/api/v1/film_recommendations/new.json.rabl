object false


extends 'api/v1/shared/header'


node :friendships do 
  friendships.map do |friendship|
  presenter = present(friendship.friend, UserPresenter)
  {
    id: presenter.user.id,
    username: presenter.username,
    friend_url: api_v1_user_path(presenter.user.id),
    avator_url: presenter.avatar_url,
    status: friendship.state
  }
  end
end
