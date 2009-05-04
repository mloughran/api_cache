require File.dirname(__FILE__) + '/spec_helper'

describe APICache do
  before :each do
    @key = 'random_key'
    @cache_data = 'data from the cache'
    @api_data = 'data from the api'
  end
  
  describe "get method" do
    before :each do
      @api = mock(APICache::API, :get => @api_data, :queryable? => true)
      @cache = mock(APICache::Cache, :get => @cache_data, :set => true)
      
      APICache::API.stub!(:new).and_return(@api)
      APICache::Cache.stub!(:new).and_return(@cache)
    end
    
    it "should fetch data from the cache if the state is :current" do
      @cache.stub!(:state).and_return(:current)
      
      APICache.get(@key).should == @cache_data
    end
    
    it "should make new request to API if the state is :refetch and store result in cache" do
      @cache.stub!(:state).and_return(:refetch)
      @cache.should_receive(:set).with(@api_data)
      
      APICache.get(@key).should == @api_data
    end
    
    it "should return the cached value if the state is :refetch but the api is not accessible" do
      @cache.stub!(:state).and_return(:refetch)
      @api.should_receive(:get).with.and_raise(APICache::CannotFetch)
      
      APICache.get(@key).should == @cache_data
    end
    
    it "should make new request to API if the state is :invalid" do
      @cache.stub!(:state).and_return(:invalid)
      
      APICache.get(@key).should == @api_data
    end
    
    it "should raise NotAvailableError if the api cannot fetch data and state is :invalid" do
      @cache.stub!(:state).and_return(:invalid)
      @api.should_receive(:get).with.and_raise(APICache::CannotFetch)
      
      lambda {
        APICache.get(@key).should
      }.should raise_error(APICache::NotAvailableError)
    end
    
    it "should make new request to API if the state is :missing" do
      @cache.stub!(:state).and_return(:missing)
      
      APICache.get(@key).should == @api_data
    end
    
    it "should raise an exception if the api cannot fetch data and state is :missing" do
      @cache.stub!(:state).and_return(:missing)
      @api.should_receive(:get).with.and_raise(APICache::CannotFetch)
      
      lambda {
        APICache.get(@key).should
      }.should raise_error(APICache::NotAvailableError)
    end
  end
end
