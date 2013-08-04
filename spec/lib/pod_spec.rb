require 'pod'

describe Pod do
  
  describe '::new' do
    context 'with no args or block' do
      subject { Pod::new }
      it { should be_kind_of(Pod::Base) }
    end
    
    context 'with service definitions' do
      subject do
        Pod.new do
          def_service(:hello) { 'hello' }
        end
      end
      it 'should return a pod with those services' do
        subject.hello.should eq('hello')
      end
    end
  end
  
  describe '::extension' do
    subject { Pod.extension }
    it 'should return a locked pod' do
      subject.should be_locked
      subject.should be_kind_of(Pod::Base)
    end
  end

end