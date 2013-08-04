if !defined?(ROOT)
  require 'pathname'
  ROOT = Pathname.new(File.join(File.dirname(__FILE__), '..')) 
end

$: << ROOT.join('lib')