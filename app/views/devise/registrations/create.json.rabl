object @user, root: false

node :user do |user|
{
  token: user.authentication_token,
  username: user.username
}