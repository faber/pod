require 'pod'
require 'logger'

module Pod
  
  ConsoleLogger = Pod.extension do

    conf[:console] ||= { log_level: Logger::DEBUG }

    def_service(:console) do |conf|

      Logger.new(STDOUT).tap do |logger|
        logger.level = conf[:console][:log_level]
      end

    end
    
  end

end