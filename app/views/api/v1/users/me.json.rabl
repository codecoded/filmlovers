object false

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end

node :user do 
  {
    username: current_user.username,
    email: current_user.email,
    first_name: current_user.first_name,
    last_name: current_user.last_name,
    avator_uri: current_user.avatar.url
  }
end

