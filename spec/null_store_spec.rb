require 'spec_helper'

describe APICache::NullStore do
  before :each do
    @store = APICache::NullStore.new
  end

  it "should NOT set" do
    @store.exists?('foo').should be_false
    @store.set('foo', 'bar')
    @store.exists?('foo').should be_false
  end

  it "should always say keys are expired" do
    @store.expired?('foo', 1).should be_true
    @store.set('foo', 'bar')
    @store.expired?('foo', 1).should be_true
  end
end
