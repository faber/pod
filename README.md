# Pod: Ruby Service Container #

Pod provides a small, simple service container class that encourages clean, testable application design without getting in the way or overly complex.


## Getting Started ##

There is no limit whatsoever on what a "service" is -- Pod makes no assumptions about this.  The pod just makes it extremely simple to setup and access your dependent services on demand without worrying about configuration.

Here are some examples of how you use pods

    # Create a pod with a definition block
    pod = Pod.new do
      conf[:db] = { host: 'localhost', port: 3306 }
    
      def_service(:hello, 'world')
      
      def_service(:db) do |conf|
        DB.new(conf[:db][:host], conf[:db][:port])
      end
    end

    # You can also add more services to an existing pod
    pod.def_service(:cat) do |conf|
      "Cat named #{conf[:cat_name]}"
    end
    
    # And you can modify it's configuration
    pod.conf[:cat_name] = 'Frank'

    # Basic service accessor, returns the service object
    pod.get_service(:hello)   # => 'world'
    
    # Dynamic service accessor methods named from the service
    pod.hello                 # => 'world'
    pod.cat                   # => 'Cat named Frank'

    # Services defined in a block are memoized
    pod.db                    # => DB instance
    pod.db                    # => same DB instance as before
    


## Extensions ##

Extensions allow you and other developers to create re-usable pods.  The `Pod.extension` method allows you to build an extension, using all the regular methods of a pod.  This is because pod extensions are actually just pod instances themselves. The only difference is that an extension is locked after it is created so it can no longer be modified.

    # Convenient way to define extensions.
    extension = Pod.extension do
      
      conf[:dog] = {
        firstname: 'Duchess',
        lastname: 'Faber'
      }
      
      def_service(:dog) do |conf|
        "#{conf[:dog][:firstname]} #{conf[:dog][:lastname]}"
      end
    end
    
    extension.locked?          # => true
    
    # Mix the extension into a pod
    pod = Pod.new
    pod.mixin(extension)
    
    # The pod now has the extension services defined,
    # as well as the extension's default configuration, which you can
    # then override.
    pod.dog                    # => "Duchess Faber"
    pod.conf[:dog][:firstname] = "Stella"
    pod.conf[:dog][:lastname] = "Blue"
    pod.dog                    # => "Duchess Faber"
    pod.realize_service(:dog)  # => "Stella Blue"
    pod.dog                    # => "Stella Blue"

# TODO #

* Namespaced services
* Richer conf object
* Set default conf values
