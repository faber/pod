# Pod - A Ruby Service Container #

Pod provides a small, simple service container class that encourages clean, testable application design without getting in the way or being overly complex.


## Getting Started ##

There is no limit whatsoever on what a "service" is -- Pod makes no assumptions about this.  The pod just simplifies the tasks of setting up and accessing your dependencies on demand without worrying about configuration.

Here are some examples of how you use pods

    # Create a pod with a definition block
    pod = Pod.new do
      conf[:db] = { host: 'localhost', port: 3306 }
    
      def_service(:hello, 'world')
      
      def_service(:db) do |pod|
        DB.new(pod.conf[:db][:host], pod.conf[:db][:port])
      end
    end

    # You can also add more services to an existing pod
    pod.def_service(:cat) do |pod|
      "Cat named #{pod.conf[:cat_name]}"
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

Extensions permit you and other developers to create re-usable pods.  To do this, you define a set of services with a default configuration.  Then, when you are creating pods, you can mixin the extension to import all of the extension's services and its default configuration.

Extensions are actually just pod instances themselves, so the extension definition block is exaclty the same as the pod creation block.  The only difference is that after an extension is created it can not be changed.

Here's an example:

    # Convenient way to define extensions.
    extension = Pod.extension do
      
      def_service(:dog) do |pod|
        pod.conf.require!({dog: [:firstname, :lastname]})
        "#{pod.conf[:dog][:firstname]} #{pod.conf[:dog][:lastname]}"
      end
    end
    
    extension.locked?          # => true
    
    # Mix the extension into a pod
    pod = Pod.new
    pod.mixin(extension)
    
    # The pod now has the extension services defined
    pod.dog                    # => raise Pod::Error with message about missing config
    pod.conf[:dog][:firstname] = 'Duchess'
    pod.conf[:dog][:lastname] = 'Faber'
    pod.dog                    # => "Duchess Faber"
    pod.conf[:dog][:firstname] = "Stella"
    pod.conf[:dog][:lastname] = "Blue"
    pod.dog                    # => "Duchess Faber"
    pod.realize_service(:dog)  # => "Stella Blue"
    pod.dog                    # => "Stella Blue"


## Environments ##

The environment is simply a string representing the name of the environment.

    p = Pod.new
    p.env # => '_default'

    p = Pod.new('testing')
    p.env # => 'testing'
    


# TODO #

* Examples of using pods in applications
* Namespaced services
* Richer conf object
* Set default conf values
