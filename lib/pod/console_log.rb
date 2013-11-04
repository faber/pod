require 'pod'
require 'logger'

module Pod
  
  ConsoleLogger = Pod.extension do

    def_service(:console) do |pod|
      
      pod.conf.require! console: [:log_level]
      
      Logger.new(STDOUT).tap do |logger|
        logger.level = pod.conf[:console][:log_level]
      end

    end
    
  end

end