class Facebook::ApplicationAPI
  extend ActiveSupport::Concern
  
  attr_reader :graph

  def initialize
    @graph = Koala::Facebook::API.new(Facebook.app_access_token)
  end

  private_class_method :new

  def self.instance
    @instance ||= new
  end

  def self.notifications(recipient_uid, href, template, ref=nil)
    instance.graph.put_connections recipient_uid, 'notifications', template: template, href: href, ref: ref
  end

  def delete_request(request_id)
    graph.delete_object request_id
  end

  
end
