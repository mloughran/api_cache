require 'spec_helper'

describe APICache::MemoryStore do
  let(:cache) { {} }
  let(:store) { APICache::MemoryStore.new(cache) }

  # Deleting created_at makes no sense given the way MemoryStore stores data
  @skip_created_at_deletion = true
  include_examples "generic store"
end
