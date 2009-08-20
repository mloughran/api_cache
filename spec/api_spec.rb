require File.dirname(__FILE__) + '/spec_helper'

describe APICache::API do
  before :each do
    FakeWeb.register_uri(:get, "http://www.google.com/", :body => "Google")
    FakeWeb.register_uri(:get, "http://froogle.google.com/", :status => 302, :location => "http://products.google.com")
    FakeWeb.register_uri(:get, "http://products.google.com/", :body => "Google Product Search")

    @options = {
      :period => 1,
      :timeout => 5
    }

    # Reset the store otherwise get queried too recently erros
    APICache.store = nil
  end

  it "should not be queryable for :period seconds after a request" do
    api = APICache::API.new('http://www.google.com/', @options)

    api.get
    lambda {
      api.get
    }.should raise_error(APICache::CannotFetch, "Cannot fetch http://www.google.com/: queried too recently")

    sleep 1
    lambda {
      api.get
    }.should_not raise_error
  end

  describe "without a block - key is the url" do

    it "should return body of a http GET against the key" do
      api = APICache::API.new('http://www.google.com/', @options)
      api.get.should =~ /Google/
    end

    it "should handle redirecting get requests" do
      api = APICache::API.new('http://froogle.google.com/', @options)
      api.get.should =~ /Google Product Search/
    end

  end

  describe "with a block" do

    it "should return the return value of the block" do
      api = APICache::API.new('http://www.google.com/', @options) do
        42
      end
      api.get.should == 42
    end

  end
end
