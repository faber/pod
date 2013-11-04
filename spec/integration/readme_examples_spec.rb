require 'spec_helper'
require 'pod'

describe 'README code examples' do
  
  describe 'Basic usage example' do
    
    it 'should work' do
      db_class = Class.new do
        def initialize(a, b); end
      end
      # Create a Pod with a definition block
      pod = Pod.new do
        conf[:db] = { host: 'localhost', port: 3306 }

        def_service(:hello, 'world')

        def_service(:db) do |pod|
          db_class.new(pod.conf[:db][:host], pod.conf[:db][:port])
        end
      end

      # You can also add more services to an existing pod
      pod.def_service(:cat) do |pod|
        "Cat named #{pod.conf[:cat_name]}"
      end

      # And you can modify it's configuration
      pod.conf[:cat_name] = 'Frank'

      # Basic service accessor, returns the service object
      expect(pod.get_service(:hello)).to eq('world')   # => 'world'

      # Dynamic service accessor methods named from the service
      expect(pod.hello).to eq('world')                 # => 'world'
      expect(pod.cat).to eq('Cat named Frank')

      # Services defined in a block are memoized
      db = pod.db
      expect(db).to be_an_instance_of(db_class)                    # => DB instance
      expect(db).to be(pod.db)                    # => same DB instance as before      
    end
    
  end
  
  describe 'Extensions example' do
    it 'should work' do
      
      # Convenient way to define extensions.
      extension = Pod.extension do
      
        def_service(:dog) do |pod|
          pod.conf.require!({dog: [:firstname, :lastname]})
          "#{pod.conf[:dog][:firstname]} #{pod.conf[:dog][:lastname]}"
        end
      end
    
      expect(extension.locked?).to be_true          # => true
    
      # Mix the extension into a pod
      pod = Pod.new
      pod.mixin(extension)
      
    
      # The pod now has the extension services defined
      expect{pod.dog}.to raise_error(Pod::Error)
      pod.conf[:dog] = {
        firstname: 'Duchess',
        lastname: 'Faber'
      }
      expect(pod.dog).to eq("Duchess Faber")                    # => "Duchess Faber"
      pod.conf[:dog][:firstname] = "Stella"
      pod.conf[:dog][:lastname] = "Blue"
      expect(pod.dog).to eq("Duchess Faber")                    # => "Duchess Faber"
      expect(pod.realize_service(:dog)).to eq("Stella Blue")  # => "Stella Blue"
      expect(pod.dog).to eq("Stella Blue")                    # => "Stella Blue"
      
    end
  end


  describe 'Environment example' do
    it 'should work' do
      
      p = Pod.new
      expect(p.env).to eq('_default') # => '_default'

      p = Pod.new('testing')
      expect(p.env).to eq('testing') # => 'testing'
            
    end
  end
end