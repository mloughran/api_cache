require 'spec_helper'

require 'dalli'

describe APICache::DalliStore do
  before :each do
    @dalli = Dalli::Client.new('localhost:11211')
    @dalli.delete('foo')
    @store = APICache::DalliStore.new(@dalli)
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

  it 'should allow checking whether a given amount of time has passed since the key was set' do
    @store.expired?('foo', 1).should be_false
    @store.set('foo', 'bar')
    @store.expired?('foo', 1).should be_false
    sleep 1
    @store.expired?('foo', 1).should be_true
  end

  context "after delete" do

    it "should no longer exist" do
      @store.set("key", "value")
      @store.delete("key")
      @store.exists?("key").should be_false
    end

  end

end
