class UserNotifier


  attr_reader :user, :channel

  CHANNEL_PREFIX = 'filmlovers_notify'
  EVENT = :notification

  def initialize(user)
    @user = user
    @channel = "private-#{CHANNEL_PREFIX}_#{user.id}"
  end

  def push(notification_view)
    message = notification_view.render_to_string
    Pusher[channel].trigger_async(EVENT, {message: message, type: notification_view.type.to_s})
  end 

  def message(message)
    Pusher[channel].trigger_async(EVENT, {message: message, type: :script})
  end

  def toast(message)
    Pusher[channel].trigger_async(EVENT, {message: message, type: :toast})
  end
  # FIXME: Unicorn does not use EventMachine which trigger_async uses

  def push_many(channels, notification_view)
    return if channels.empty?
    message = notification_view.render_to_string
    Pusher.trigger_async(channels, EVENT, {message: message, type: notification_view.type.to_s})    
  end

  def push_to_mobile(message)
    Log.debug message
    return unless has_mobile?
    n = Rapns::Apns::Notification.new
    n.app = Rapns::Apns::App.find_by_name(AppConfig.ios_app)
    n.device_token = user.mobile_devices.find_by_provider('iPhone').token.gsub(' ','')
    n.alert = message
    # n.attributes_for_device = {:foo => :bar}
    n.save!
    Log.debug 'Mobile recommendation recorded - ensure daemon is running'
    true
  rescue => msg
    Log.error "Unable to send to user #{user.username} mobile message #{message}. #{msg}"
  end

  def has_mobile?
    return true if user.mobile_devices.registered? :iPhone
    Log.debug "#{user.username} had no mobile device registered"
    false
  end
end