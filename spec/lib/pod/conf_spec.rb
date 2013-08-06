require 'pod/conf'

describe Pod::Conf do
  subject { described_class.new }
  
  it 'should be like a hash' do
    subject[:a] = 'b'
    subject[:a].should eq('b')
    subject.map{|k,v|[k,v]}.should eq([[:a, 'b']])
  end
  
  describe '#require!' do
    describe 'raising an exception when requirements arent met' do
      it 'should take a single key requirement' do
        expect { subject.require!(:firstname) }.to raise_error(Pod::Error)
        subject[:firstname] = 'David'
        expect { subject.require!(:firstname) }.not_to raise_error
      end
      
      it 'should take a list of keys' do
        test_proc = proc { subject.require!(:first, :last) }
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:first] = 'David'
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:last] = 'Faber'
        expect(&test_proc).not_to raise_error
      end
      
      it 'should take a hash requirement' do
        test_proc = proc { subject.require!(:name => [:first, :last]) }
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:name] = {first: 'David'}
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:name][:last] = 'Faber'
        expect(&test_proc).not_to raise_error
      end
      
      it 'should take a wild mix of all types of requirements' do
        test_proc = proc do
          subject.require!({a: [:b], c: [:d, :e]}, :f, :g, [:h, :i, {j: [:k, :l]}])
        end
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:a] = {b: 'val'}
        subject[:c] = {d: 'val', e: 'val'}
        subject[:f] = 'val'
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:g] = 'val'
        subject[:h] = 'val'
        expect(&test_proc).to raise_error(Pod::Error)
        subject[:i] = 'val'
        subject[:j] = {k: 'val', l: 'val'}
        expect(&test_proc).not_to raise_error
      end
    end
  end

  describe '#get' do
    it 'should return a value if present' do
      subject[:a] = 'b'
      subject.get(:a).should eq('b')
      subject[:c] = {d: 'f'}
      subject.get(:c, :d).should eq('f')
    end
    
    it 'should return nil if not present' do
      subject.get(:a).should be_nil
      subject.get(:b, :c).should be_nil
    end
    
  end
end