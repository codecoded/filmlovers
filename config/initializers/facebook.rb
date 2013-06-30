module Facebook
  CONFIG = YAML.load_file(Rails.root.join("config/facebook.yml"))[Rails.env]
  extend self
  
  def app_id
    CONFIG['app_id']
  end
  
  def secret
    CONFIG['secret_key']
  end

  def app_access_token
    "#{app_id}|#{secret}"
  end

  def namespace
    CONFIG['namespace']
  end

  def canvas_app_url
    "https://apps.facebook.com/#{namespace}"
  end
  
  def permissions
    [ :publish_actions,:email ].join ','
  end
end
