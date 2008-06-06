require File.dirname(__FILE__) + '/spec_helper'

describe APICache do
  before :each do
    APICache.start(APICache::MemoryStore)
    @key = 'random_key'
    @data = 'some bit of data'
  end
  
  describe "get method" do
    it "should fetch data from the cache if the state is :current" do
      APICache.cache.should_receive(:state).and_return(:current)
      APICache.cache.should_receive(:get).and_return(@data)
      
      APICache.get(@key).should == @data
    end
    
    it "should make new request to API if the state is :refetch" do
      APICache.cache.should_receive(:state).and_return(:refetch)
      APICache.api.should_receive(:get).with(@key, 5).and_return(@data)
      
      APICache.get(@key).should == @data
    end
    
    it "should return the cached value if the api cannot fetch data and state is :refetch" do
      APICache.cache.should_receive(:state).and_return(:refetch)
      APICache.api.should_receive(:get).with(@key, 5).and_raise(APICache::CannotFetch)
      APICache.cache.should_receive(:get).and_return(@data)
      
      APICache.get(@key).should == @data
    end
    
    it "should make new request to API if the state is :invalid" do
      APICache.cache.should_receive(:state).and_return(:invalid)
      APICache.api.should_receive(:get).with(@key, 5).and_return(@data)
      
      APICache.get(@key).should == @data
    end
    
    it "should raise an exception if the api cannot fetch data and state is :invalid" do
      APICache.cache.should_receive(:state).and_return(:invalid)
      APICache.api.should_receive(:get).with(@key, 5).and_raise(APICache::CannotFetch)
      
      lambda { APICache.get(@key).should }.should raise_error(APICache::NotAvailableError)
    end
    
    it "should make new request to API if the state is :missing" do
      APICache.cache.should_receive(:state).and_return(:missing)
      APICache.api.should_receive(:get).with(@key, 5).and_return(@data)
      
      APICache.get(@key).should == @data
    end
    
    it "should raise an exception if the api cannot fetch data and state is :missing" do
      APICache.cache.should_receive(:state).and_return(:missing)
      APICache.api.should_receive(:get).with(@key, 5).and_raise(APICache::CannotFetch)
      
      lambda { APICache.get(@key).should }.should raise_error(APICache::NotAvailableError)
    end
  end
end
