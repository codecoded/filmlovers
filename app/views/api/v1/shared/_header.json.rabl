node :header do
  {
    version:    'v1',
    domain:     "#{request.protocol}#{request.host}:#{request.port}",
    timestamp:  Time.now.utc,
    url:        url_for(params),
    token:      if current_user then current_user.authentication_token end
  }
end 
