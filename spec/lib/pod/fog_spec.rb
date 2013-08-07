require 'spec_helper'
require 'pod/fog'

describe 'Pod::Fog' do
  subject { Pod::Fog }
  
  let(:pod) { Pod.new }
  
  let(:valid_conf) do
    { fog: {mock: true},
      aws: {secret: 'asecret', access: 'access'}}
  end
  
  
  it { should be_kind_of(Pod::Base) }
  it { should be_locked }

  describe 'with proper configuration' do
    
    before(:each) do
      pod.mixin subject
      pod.env.conf.replace valid_conf
    end

    it 'should provide a service "fog" which returns the Fog base module' do
      proc { pod.fog }.should_not raise_error
    end    
    it 'should provide a service "rds" which like a Fog::AWS::RDS' do
      proc { pod.fog_rds }.should_not raise_error
    end
    it 'should provide a service "compute" which like a Fog::Compute instance' do
      proc { pod.fog_compute }.should_not raise_error
    end
  end
    
end