Gem::Specification.new do |s|
  s.name          = "pod"
  s.version       = '0.0.1'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["David Faber"]
  s.email         = ["david@sierradev.com"]
  s.homepage      = "http://github.com/faber/pod"
  s.summary       = "Service container for dependency injection."
  s.description   = "Pod is a simple data structure for defining, instantiating and accessing your services when using DI."

  # s.required_rubygems_version = ">= 1.3.6"
  # s.rubyforge_project         = "vagrant"

  # s.add_dependency "fog", "~> 0.3.7"

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]



  s.add_development_dependency('rspec', '~> 2.14.0')
  s.add_development_dependency('rake')

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")


end