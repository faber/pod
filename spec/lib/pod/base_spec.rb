require 'spec_helper'
require 'pod/base'
require 'pod/env'

describe Pod::Base do
  subject { described_class.new }
  
  let(:env) { 'test' }
  let(:a_service) { Object.new }
  
  let(:pod_with_services) do
    described_class.new.tap do |pod|
      pod.conf[:key] = '1234'
      
      pod.def_service(:log, 'hello')
      pod.def_service(:db, Object.new)
      pod.def_service(:calc) { "calculator" }
    end
  end

  let(:log_extension) do
    described_class.new.tap do |obj|
      obj.def_service(:log) { "hello" }
      obj.def_service(:level) {|pod| pod.conf[:level] }
    end
  end
    
  it 'should start empty' do
    subject.should be_empty
  end
  
  describe 'initializing with a block' do
    it 'should execute the block in the context of the new object' do
      container = described_class.new(env) do
        def_service :my_service, 'hello'
        def_service :blocky do
          'block service!'
        end
      end
      container.get_service(:my_service).should == 'hello'
      container.get_service(:blocky).should == 'block service!'
    end
  end
  
  describe 'initializing with an argument' do
    context 'when the argument is a string' do
      it 'should set the env attribute' do
        env = double
        described_class.new(env).env.should be(env)
      end
    end
  end
  
  describe '#conf' do
    it 'should be an initially empty hash' do
      subject.conf.should be_empty
      subject.conf[:db_user] = 'root'
      subject.conf[:db_user].should eq('root')
    end
    # 
    # it 'should delegate to the pod\'s env' do
    #   env = double(:conf => {testing: 123})
    #   described_class.new(env).conf[:testing].should be(123)
    # end
  end
  
  describe '#def_service and #get_service' do
    it 'should register services by block' do
      b = proc{ 'horray' }
      subject.def_service(:service_name, &b)
      subject.get_service(:service_name).should == 'horray'
    end
    
    it 'should pass itself to service initialization blocks' do
      subject.conf[:host] = 'localhost'
      subject.conf[:port] = 123
      subject.def_service(:cache) do |pod|
        Struct.new(:host, :port).new(pod.conf[:host], pod.conf[:port])
      end
      cache = subject.get_service(:cache)
      cache.host.should == subject.conf[:host]
      cache.port.should == subject.conf[:port]
    end
    
    it 'should only execute the registration block once' do
      i = 0
      subject.def_service(:db) { i += 1; 'db' }
      db1 = subject.get_service(:db)
      db2 = subject.get_service(:db)
      db1.should eq('db')
      db2.should equal(db1)
      i.should == 1
    end

    it 'should register services with concrete objects' do
      logger_object = Object.new
      subject.def_service(:logger, logger_object)
      subject.get_service(:logger).should be(logger_object)
    end
  end
  
  describe '#realize_service' do
    it 'should recreate the service object if it was defined with a block' do
      subject.def_service(:db) { Object.new }
      s1 = subject.realize_service(:db)
      s2 = subject.realize_service(:db)
      expect(s1).not_to be(s2)
    end
    it 'should just return the same value if it was not defined with a block' do
      subject.def_service(:string, 'hello')
      s1 = subject.realize_service(:string)
      s2 = subject.realize_service(:string)
      expect(s1).to be(s2)
    end
    it 'should replace the currently memoized service object' do
      subject.def_service(:service) {|pod| pod.conf[:a] }
      subject.get_service(:service).should == nil
      subject.conf[:a] = 'b'
      subject.get_service(:service).should == nil
      subject.realize_service(:service).should == 'b'
      subject.get_service(:service).should == 'b'
    end
  end

  describe '#mixin' do
    it 'should include the extensions services' do
      subject.mixin(log_extension)
      subject.log.should eq('hello')
    end
    
    it 'should evaluate extension services in the context of this pod' do
      env = double(conf: {level: 'HIGH'})
      pod = described_class.new
      pod.conf[:level] = 'HIGH'
      pod.mixin(log_extension)
      pod.level.should eq('HIGH')
    end
  end

  describe '#services' do
    it 'should be an array of service names' do
      services = pod_with_services.services
      Set.new(services).should eq(Set.new([:log, :db, :calc]))
    end
  end

  describe 'dynamic service getters' do
    it 'should get the service by the name of the method' do
      subject.def_service(:my_service_name, a_service)
      expect(subject).to receive(:get_service).with(:my_service_name, subject).and_return(a_service)
      subject.my_service_name
    end
  end
end