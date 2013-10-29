require 'pod'
require 'pod/conf'

module Pod
  class Env
    attr_reader :name, :conf, :pod
    attr_writer :conf
    def initialize(name=nil)
      @name = name
      @conf = Pod::Conf.new
      @pod = Pod.new(self)
    end
    
    def inspect
      '#<%s:%s %s>' % [
        self.class.name,
        self.__id__.to_s(16),
        instance_variables.map do |var|
          if var == :@conf
            '@conf=<... conf hash ...>'
          elsif var == :@pod
            '@pod=#<%s:%s>' % [
              pod.class.name,
              pod.__id__.to_s(16)
            ]
          else
            '%s=%s' % [
              var,
              instance_variable_get(var).inspect
            ]
          end
        end.join(" ")
      ]
    end
  
  end
end