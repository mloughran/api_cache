require 'spec_helper'

describe APICache::Cache do
  before :each do
    @options = {
      :cache => 1,    # After this time fetch new data
      :valid => 2   # Maximum time to use old data
    }
  end

  it "should set and get" do
    cache = APICache::Cache.new('flubble', @options)

    cache.set('Hello world')
    cache.get.should == 'Hello world'
  end

  it "should md5 encode the provided key" do
    cache = APICache::Cache.new('test_md5', @options)
    APICache.store.should_receive(:set).
      with('9050bddcf415f2d0518804e551c1be98', 'md5ing?')
    cache.set('md5ing?')
  end

  it "should report correct invalid states" do
    cache = APICache::Cache.new('foo', @options)

    cache.state.should == :missing
    cache.set('foo')
    cache.state.should == :current
    sleep 1
    cache.state.should == :refetch
    sleep 1
    cache.state.should == :invalid
  end

  it "should initially have invalid state" do
    cache = APICache::Cache.new('foo', @options)
    cache.state.should == :invalid
  end

end
