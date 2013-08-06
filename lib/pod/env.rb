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
  
  end
end