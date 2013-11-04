module Pod
  class Base

    def initialize(env=nil, &block)
      @env = env || '_default'
      @conf = Pod::Conf.new
      @services = {}
      @locked = false
      @realized = {}
      instance_eval(&block) if block_given?
    end

    def lock!
      @locked = true
      self
    end
    
    def locked?
      @locked
    end
    
    def env
      @env
    end
    
    def conf
      locked? ? @conf.dup : @conf
    end

    def empty?
      @services.empty?
    end

    def services
      @services.keys
    end

    def get_service(name, conf=nil)
      if !@realized.has_key?(name)
        @realized[name] = realize_service(name, conf)
      end
      @realized[name]
    end
    
    def realize_service(name, pod=nil)
      if @services[name].kind_of?(Proc)
        # realized = @services[name].call(conf || self.conf)
        realized = @services[name].call(pod || self)
      else
        realized = @services[name]
      end
      @realized.delete name
      realized
    end
    
    # Mutators
    
    def def_service(name, value=nil, &block)
      unless_locked! { create_service_definition(name, value, &block) }
    end

    def mixin(pod)
      unless_locked! do 
        create_service_definitions_from_pod(pod)
        # merge_default_configuration(pod)
      end
      self
    end
    
    
    private
    
    def conf=(conf)
      @conf = conf
    end
    
    def unless_locked!
      locked? ?
        raise("Can not modify a locked Pod") :
        yield
    end
    
    def create_service_definition(name, value=nil, &block)
      if block_given?
        @services[name] = block
      else
        @services[name] = value
      end

      define_singleton_method(name) { get_service(name, self) }
    end

    def create_service_definitions_from_pod(extension_pod)
      extension_pod.services.each do |service_name|
        def_service(service_name) do |pod|
          extension_pod.realize_service(service_name, pod)
        end
      end
    end
    
    def merge_default_configuration(pod)
      self.conf = deep_merge_two_hashes pod.conf, self.conf
    end
    
    def deep_merge_two_hashes(hash1, hash2)
      hash1.merge(hash2) do |key, oldval, newval|
        oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
        newval = newval.to_hash if newval.respond_to?(:to_hash)
        oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? deep_merge_two_hashes(oldval, newval) : newval
      end
    end

  end
end