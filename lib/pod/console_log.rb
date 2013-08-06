require 'pod'
require 'logger'

module Pod
  
  ConsoleLogger = Pod.extension do

    def_service(:console) do |conf|
      
      conf.require! console: [:log_level]
      
      Logger.new(STDOUT).tap do |logger|
        logger.level = conf[:console][:log_level]
      end

    end
    
  end

end