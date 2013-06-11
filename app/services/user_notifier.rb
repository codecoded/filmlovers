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
    Pusher[channel].trigger(EVENT, {message: message, type: notification_view.type.to_s})
  end 

  def message(message)
    Pusher[channel].trigger(EVENT, {message: message, type: :script})
  end
  # FIXME: Unicorn does not use EventMachine which trigger_async uses

  def push_many(channels, notification_view)
    return if channels.empty?
    message = notification_view.render_to_string
    Pusher.trigger(channels, EVENT, {message: message, type: notification_view.type.to_s})    
  end

end