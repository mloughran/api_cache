require 'spec_helper'

require 'moneta'

describe APICache::MonetaStore do
  let(:cache) { Moneta.new(:Memcached) }
  let(:store) { APICache::MonetaStore.new(cache) }

  include_examples "generic store"
end
