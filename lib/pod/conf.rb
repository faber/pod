require 'pod/error'

module Pod
  class Conf < Hash
    def require!(*args)
      missing = []
      
      args.each do |arg|
        missing += validate_requirement(arg, self)
      end
      
      
      
      # args.each do |arg|
      #   if arg.kind_of?(Hash)
      #     arg.each do |key, value|
      #       
      #     end
      #   elsif !has_key?(arg)
      #     missing << arg
      #   end
      # end
      if !missing.empty?
        raise Pod::Error, "required key(s) #{missing.join(', ')} not found in conf #{self.inspect}"
      end
    end

    def get(*keys)
      keys.inject(self) do |hash, key|
        if hash.nil?
          nil
        elsif hash.has_key?(key)
          hash[key]
        else
          nil
        end
      end
    end
    
    private
    
    def validate_requirement(arg, base)
      case arg
      when Hash
        validate_hash_requirement(arg, base)
      when Array
        validate_array_requirement(arg, base)
      else
        validate_scalar_environment(arg, base)
      end
    end
    
    def validate_hash_requirement(hash, base)
      hash.map do |key, value|
        if !base.has_key?(key)
          key
        else
          new_base = self.class.new.replace(base[key])
          missing = validate_requirement(value, new_base)
          if !missing.empty?
            {key => missing}
          else
            nil
          end
        end
      end.compact
    end
    
    def validate_array_requirement(args, base)
      args.map { |arg| validate_requirement(arg, base) }.reject(&:empty?)
    end
    
    def validate_scalar_environment(scalar, base)
      base.has_key?(scalar) ?
        [] :
        [scalar]
    end
    
    class NilConfProxy
      
    end
  end
end