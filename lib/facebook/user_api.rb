class Facebook::UserAPI
  extend ActiveSupport::Concern
  
  attr_reader :graph, :user, :fb_oauth


  def initialize(user)
    @user = user
    @graph = Koala::Facebook::API.new user.oauth_token
    @fb_oauth = Koala::Facebook::OAuth.new
  end

  def self.user_from_token(token)
     @graph = Koala::Facebook::API.new token
     @graph.get_object('me')
  end

  def friends(fields='name', limit='')
    graph.get_connections user.uid, 'friends', :fields => fields, limit:limit
  end

  def publish_story(action, object, url)
    graph.put_connections('me', action, object => url)['id']
  end

  def notifications(href, template, ref=nil)
    Facebook::ApplicationAPI.notifications user.uid, href, template, ref
  end

  def delete_request(request_id)
    graph.delete_object request_id
  end

  def avatar(height=80, width=80)
    "https://graph.facebook.com/#{user.uid}/picture?height=#{height}&width=#{width}"
  end

  def exchange_token
    fb_oauth.exchange_access_token user.oauth_token
  end
end
