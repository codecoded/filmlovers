if Rails.env != 'test'
  email_settings = YAML.load(ERB.new(File.read(Rails.root.join("config/emailers.yml"))).result)[Rails.env]
  ActionMailer::Base.smtp_settings = email_settings unless email_settings.nil?
end
