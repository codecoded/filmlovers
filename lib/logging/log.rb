class Log 

  def initialize(logger)
    $logger = logger
  end 

  def self.instance
    $logger ||= Logger.new 
  end

  def self.error(msg); instance.error(msg) end
  def self.debug(msg); instance.debug(msg) end
  def self.fatal(msg); instance.fatal(msg) end
  def self.info(msg); instance.info(msg) end
  def self.warn(msg); instance.warn(msg) end

end