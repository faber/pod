require 'pod/base'

module Pod
  
  def self.new(*args, &block)
    Pod::Base.new(*args, &block)
  end
  
  def self.extension(*args, &block)
    new(*args, &block).lock!
  end

  # attr_reader :conf
  # 
  # def initialize(&block)
  #   @services = {}
  #   @conf = {}
  # 
  #   instance_eval(&block) if block_given?
  # end
  # 
  # def conf
  #   @conf
  # end
  # 
  # def empty?
  #   @services.empty?
  # end
  # 
  # def services
  #   @services.keys
  # end
  # 
  # def def_service(name, value=nil, &block)
  #   if block_given?
  #     @services[name] = block
  #   else
  #     @services[name] = value
  #   end
  # 
  #   define_singleton_method(name) { get_service(name, conf) }
  # end
  # 
  # 
  # def get_service(name, conf=nil)
  #   conf = self.conf if conf.nil?
  #   
  #   if @services[name].kind_of?(Proc)
  #     # @services[name] = instance_eval(&@services[name])
  #     @services[name] = @services[name].call(conf)
  #   end
  #   @services[name]
  # end
  # 
  # def mixin(pod)
  #   pod.services.each do |service_name|
  #     def_service(service_name) do
  #       pod.get_service(service_name, conf)
  #       # duped_pod = pod.dup
  #       # duped_pod.conf.merge
  #       # pod.conf.merge()
  #       # pod.get_service(extension_service)
  #     end
  #   end
  # end
  
end
