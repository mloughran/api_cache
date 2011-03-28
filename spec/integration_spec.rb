require 'spec_helper'

describe "api_cache" do
  before :each do
    stub_request(:get, "http://www.google.com/").to_return(:body => "Google")

    APICache.store = nil
  end

  it "should work when url supplied" do
    APICache.get('http://www.google.com/').should =~ /Google/
  end

  it "should work when block supplied" do
    APICache.get('foobar') do
      42
    end.should == 42
  end

  it "should raise error raised in block unless key available in cache" do
    lambda {
      APICache.get('foo') do
        raise RuntimeError, 'foo'
      end
    }.should raise_error(RuntimeError, 'foo')

    APICache.get('foo', :period => 0) do
      'bar'
    end

    lambda {
      APICache.get('foo') do
        raise RuntimeError, 'foo'
      end
    }.should_not raise_error
  end

  it "should raise APICache::TimeoutError if the API call times out unless data available in cache" do
    lambda {
      APICache.get('foo', :timeout => 1) do
        sleep 1.1
      end
    }.should raise_error APICache::TimeoutError, 'Timed out when calling API (timeout 1s)'

    APICache.get('foo', :period => 0) do
      'bar'
    end

    lambda {
      APICache.get('foo', :timeout => 1) do
        sleep 1.1
      end
    }.should_not raise_error
  end

  it "should return a default value rather than raising an exception if :fail passed" do
    APICache.get('foo', :fail => "bar") do
      raise 'foo'
    end.should == 'bar'
  end

  it "should accept a proc to fail" do
    APICache.get('foo', :fail => lambda { "bar" }) do
      raise 'foo'
    end.should == 'bar'
  end

  it "should accept nil values for :fail" do
    APICache.get('foo', :fail => nil) do
      raise 'foo'
    end.should == nil
  end
end
