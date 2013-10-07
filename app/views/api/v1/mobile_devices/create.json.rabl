object false


extends 'api/v1/shared/header'

node :user do
  {
    id: current_user.id,
    username: current_user.username,
    devices: current_user.mobile_devices.map {|d| {provider: d.provider, token: d.token}}
  }
end