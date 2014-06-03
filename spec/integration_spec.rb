require "spec_helper"

describe "api_cache" do
  before :each do
    stub_request(:get, "http://www.google.com/").to_return(body: "Google")

    APICache.store = nil
  end

  it "should work when url supplied" do
    expect(APICache.get("http://www.google.com/")).to match(/Google/)
  end

  it "should work when block supplied" do
    expect(APICache.get("foobar") do
      42
    end).to eq(42)
  end

  it "should raise error raised in block unless key available in cache" do
    expect(lambda do
      APICache.get("foo") do
        fail("foo")
      end
    end).to raise_error(RuntimeError, "foo")

    APICache.get("foo", period: 0) do
      "bar"
    end

    expect(lambda do
      APICache.get("foo") do
        fail("foo")
      end
    end).to_not raise_error
  end

  it "should raise APICache::TimeoutError if the API call times
  out unless data available in cache" do
    expect(lambda do
      APICache.get("foo", timeout: 1) do
        sleep(1.1)
      end
    end).to raise_error(APICache::TimeoutError,
                        "APICache foo: Request timed out (timeout 1s)")

    APICache.get("foo", period: 0) do
      "bar"
    end

    expect(lambda do
      APICache.get("foo", timeout: 1) do
        sleep(1.1)
      end
    end).to_not raise_error
  end

  it "should return a default value rather than raising an
  exception if :fail passed" do
    expect(APICache.get("foo", fail: "bar") do
      fail("foo")
    end).to eq("bar")
  end

  it "should accept a proc to fail" do
    expect(APICache.get("foo", fail: -> { "bar" }) do
      fail("foo")
    end).to eq("bar")
  end

  it "should accept nil values for :fail" do
    expect(APICache.get("foo", fail: nil) do
      fail("foo")
    end).to be_nil
  end
end
