class Facebook::UserAPI
  extend ActiveSupport::Concern
  
  attr_reader :graph, :user


  def initialize(user)
    @user = user
    @graph = Koala::Facebook::API.new user.oauth_token
  end

  def friends(fields='name', limit='')
    graph.get_connections user.uid, 'friends', :fields => fields, limit:limit
  end

  def publish_story(action, object, url)
    graph.put_connections('me', action, object => url)['id']
  end

  def delete_request(request_id)
    graph.delete_object request_id
  end
end
