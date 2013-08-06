require 'spec_helper'
require 'pod/env'

describe Pod::Env do
  subject { described_class.new }
  
  describe '#name' do
    it 'should return the name the env was initialized with' do
      env = described_class.new('testing')
      env.name.should eq('testing')
    end
  end
  
  describe '#conf property' do
    it 'should start an empty hash' do
      subject.conf.should be_empty
      subject.conf[:a] = 'b'
      subject.conf[:a].should eq('b')
    end
    it 'should be writable' do
      subject.conf = {keys: 'and values'}
      subject.conf[:keys].should eq('and values')
    end
  end
  
  describe '#pod' do
    it 'should be a pod' do
      subject.pod.should respond_to(:def_service)
    end
  end
end