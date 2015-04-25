require 'spec_helper'

require 'redis'

describe APICache::DalliStore do
  before :each do
    @redis = Redis.new # uses default server localhost#6379
    @store = APICache::RedisStore.new(@redis)
    @store.clear
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

  it 'clears all keys' do
    @store.set('foo', 'bar')
    expect(@store.count).to eq 2 # foo, foo_created_at
    @store.clear
    expect(@store.count).to eq 0
  end

  it 'counts keys' do
    expect{
      @store.set('foo', 'bar')
      # foo, foo_created_at
    }.to change(@store, :count).by(2)
  end

  context '#keys' do
    it 'finds all keys' do
      @store.set('foo', 'bar')
      keys = @store.keys
      expect(keys).to eq ['foo', 'foo_created_at']
    end

    it 'finds keys matching a pattern' do
      @store.set('foo', 'bar')
      @store.set('foo2', 'bar')
      keys = @store.keys('*2')
      expect(keys).to eq ['foo2']
    end
  end

  context "after delete" do

    it "should no longer exist" do
      @store.set("key", "value")
      @store.delete("key")
      @store.exists?("key").should be_false
    end

  end

end
