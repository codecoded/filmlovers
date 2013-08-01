object false


extends 'api/v1/shared/header'

node :user do
  {
    id: current_user.id,
    username: current_user.username
  }
end