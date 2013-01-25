$logger = Log4r::Logger.new('bgoslots')
$logger.outputters << Log4r::Outputter.stdout
$logger.outputters << Log4r::FileOutputter.new('log_app', :filename =>  'log/application.log')
