require 'spec_helper'
require 'pod/console_log'

describe 'Pod::ConsoleLogger' do

  subject { Pod::ConsoleLogger }

  let(:pod) { Pod.new }

  let(:valid_configuration) do 
    {  }
  end


  it { should be_kind_of(Pod::Base) }
  describe 'default log level' do
    it 'should be debug' do
      subject.conf[:console][:log_level].should == Logger::DEBUG
    end
  end

  describe 'with proper configuration' do
    before(:each) do
      pod.mixin subject
    end
    
    it 'should provide a service "console" which is like a Logger' do
      pod.console.should respond_to(:debug)
      pod.console.should respond_to(:info)
      pod.console.should respond_to(:warn)
      pod.console.should respond_to(:error)
      pod.console.should respond_to(:fatal)
    end
    
    it 'should set the log level of the "console" service' do
      pod.conf[:console][:log_level] = Logger::INFO
      pod.console.level.should eq(Logger::INFO)
    end
  end
  

end