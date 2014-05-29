require 'spec_helper'

describe APICache::Cache do
  before :each do
    @options = {
      cache: 1,    # After this time fetch new data
      valid: 2   # Maximum time to use old data
    }
  end

  it 'should set and get' do
    cache = APICache::Cache.new('flubble', @options)

    cache.set('Hello world')
    expect(cache.get).to eq('Hello world')
  end

  it 'should md5 encode the provided key' do
    cache = APICache::Cache.new('test_md5', @options)
    expect(APICache.store).to receive(:set)
    .with('9050bddcf415f2d0518804e551c1be98', 'md5ing?')
    cache.set('md5ing?')
  end

  it 'should report correct invalid states' do
    cache = APICache::Cache.new('foo', @options)

    expect(cache.state).to eq(:missing)
    cache.set('foo')
    expect(cache.state).to eq(:current)
    sleep(1)
    expect(cache.state).to eq(:refetch)
    sleep(1)
    expect(cache.state).to eq(:invalid)
  end

  it 'should initially have invalid state' do
    cache = APICache::Cache.new('foo', @options)
    expect(cache.state).to eq(:invalid)
  end
end
