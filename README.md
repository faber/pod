# Pod - A Ruby Service Container #

Pod provides a small, simple service container class that encourages clean, testable application design without getting in the way or being overly complex.


## Getting Started ##

There is no limit whatsoever on what a "service" is -- Pod makes no assumptions about this.  The pod just simplifies the tasks of setting up and accessing your dependencies on demand without worrying about configuration.

Here are some examples of how you use pods

    # Create a pod with a definition block
    pod = Pod.new do
      env.conf[:db] = { host: 'localhost', port: 3306 }
    
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
    pod.env.conf[:cat_name] = 'Frank'

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
      
      def_service(:dog) do |conf|
        conf.require!({dog: [:firstname, :lastname]})
        "#{conf[:dog][:firstname]} #{conf[:dog][:lastname]}"
      end
    end
    
    extension.locked?          # => true
    
    # Mix the extension into a pod
    pod = Pod.new
    pod.mixin(extension)
    
    # The pod now has the extension services defined
    pod.dog                    # => raise Pod::Error with message about missing config
    pod.env.conf[:dog][:firstname] = 'Duchess'
    pod.env.conf[:dog][:lastname] = 'Faber'
    pod.dog                    # => "Duchess Faber"
    pod.env.conf[:dog][:firstname] = "Stella"
    pod.env.conf[:dog][:lastname] = "Blue"
    pod.dog                    # => "Duchess Faber"
    pod.realize_service(:dog)  # => "Stella Blue"
    pod.dog                    # => "Stella Blue"


## Environments ##

Above you'll notice that in order to modify the conf, we had to grab it through the pod's env.
In an app, you will actually start with an env, and then use it's pod to define services.

    env = Pod::Env.new('dev')
    
    env.conf[:rock_ids] = [1,2,3]
    
    env.pod.def_service(:rocks) { |conf| Rock.all(conf[:rock_ids]) }
    
    env.pod.rocks     # => Array of Rock objects



# TODO #

* Examples of using pods in applications
* Namespaced services
* Richer conf object
* Set default conf values
