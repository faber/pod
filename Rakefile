require 'rspec/core/rake_task'


RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = '--color'
end

task :default => :spec

task :console do
  ARGV.clear
  require 'irb'
  $: << File.join(File.dirname(__FILE__), 'lib')
  IRB.start
end

task :irb => :console