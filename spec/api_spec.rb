require File.dirname(__FILE__) + '/spec_helper'

describe APICache::API do
  it "should handle redirecting get requests" do
    api = APICache::API.new
    lambda {
      api.get('http://froogle.google.com', 5)
    }.should_not raise_error(APICache::CannotFetch)
  end
end