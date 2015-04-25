require 'spec_helper'

require 'dalli'

describe APICache::DalliStore do
  let(:cache) { Dalli::Client.new("localhost:11211") }
  let(:store) { APICache::DalliStore.new(cache) }

  include_examples "generic store"
end
