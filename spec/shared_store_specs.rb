shared_examples "generic store" do
  before :each do
    cache.delete("foo")
  end

  it "should allow set and get" do
    store.set("foo", "bar")
    store.get("foo").should == "bar"
  end

  it "should report existence" do
    store.exists?("foo").should == false
    store.set("foo", "bar")
    store.exists?("foo").should == true
  end

  it "should allow checking expiration" do
    store.set("foo", "bar")
    store.expired?("foo", 1).should == false
    store.expired?("foo", 0).should == true
  end

  it "should return nil if not found" do
    store.get("nothing").should == nil
  end

  it "should be possible to delete" do
    store.set("foo", "bar")
    store.delete("key")
    store.exists?("key").should == false
    store.get("key").should == nil
  end

  unless @skip_created_at_deletion
    it "should claim that key has expired if _created_at key is missing" do
      store.set("key", "bar")
      store.expired?("foo", 10).should == false
      cache.delete("foo_created_at")
      store.expired?("foo", 10).should == true
    end
  end
end
