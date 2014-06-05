require "spec_helper"

describe APICache::NullStore do
  before :each do
    @store = APICache::NullStore.new
  end

  it "should NOT set" do
    expect(@store.exists?("foo")).to be false
    @store.set("foo", "bar")
    expect(@store.exists?("foo")).to be false
  end

  it "should allows say keys are expired" do
    expect(@store.expired?("foo", 1)).to be true
    @store.set("foo", "bar")
    expect(@store.expired?("foo", 1)).to be true
  end
end
