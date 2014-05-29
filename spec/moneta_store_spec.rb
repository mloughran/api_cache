require 'spec_helper'
require 'moneta'
require 'moneta/memcache'

describe APICache::MonetaStore do
  before(:each) do
    @moneta = Moneta::Memcache.new(server: 'localhost')
    @moneta.delete('foo')
    @store = APICache::MonetaStore.new(@moneta)
  end

  it 'should set and get' do
    @store.set('key', 'value')
    expect(@store.get('key')).to eq('value')
  end

  it 'should allow checking whether a key exists' do
    expect(@store.exists?('foo')).to be false
    @store.set('foo', 'bar')
    expect(@store.exists?('foo')).to be true
  end

  it 'should allow checking whether a given amount of time
  has passed since the key was set' do
    expect(@store.expired?('foo', 1)).to be false
    @store.set('foo', 'bar')
    expect(@store.expired?('foo', 1)).to be false
    sleep(1)
    expect(@store.expired?('foo', 1)).to be true
  end

  context 'after delete' do

    it 'should no longer exist' do
      @store.set('key', 'value')
      @store.delete('key')
      expect(@store.exists?('key')).to be false
    end
  end
end
