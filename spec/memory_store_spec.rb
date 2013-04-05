require 'spec_helper'

describe APICache::MemoryStore do
  before :each do
    @store = APICache::MemoryStore.new
  end

  it "should set" do
    @store.exists?('foo').should be_false
    @store.set('foo', 'bar')
    @store.exists?('foo').should be_true
	@store.get('foo').should == 'bar'
  end

  it "should return nil if not found" do
    @store.get('nothing').should be_nil
  end
end
