require 'spec_helper'

require 'redis'

describe APICache::DalliStore do
  before :each do
    @redis = Redis.new # uses default server localhost#6379
    @store = APICache::RedisStore.new(@redis)
  end

  it 'should set and get' do
    @store.set('key', 'value')
    @store.get('key').should == 'value'
  end

  it 'should allow checking whether a key exists' do
    @store.exists?('foo').should be_false
    @store.set('foo', 'bar')
    @store.exists?('foo').should be_true
  end

  context "after delete" do

    it "should no longer exist" do
      @store.set("key", "value")
      @store.delete("key")
      @store.exists?("key").should be_false
    end

  end

end
