require 'spec_helper'

describe APICache do
  before :each do
    @key = 'random_key'
    @cache_data = 'data from the cache'
    @api_data = 'data from the api'
  end
  
  describe "store=" do
    before :each do
      APICache.store = nil
    end

    it "should use APICache::MemoryStore by default" do
      expect(APICache.store).to be_kind_of(APICache::MemoryStore)
    end

    it "should allow instances of APICache::AbstractStore to be passed" do
      APICache.store = APICache::MemoryStore.new
      expect(APICache.store).to be_kind_of(APICache::MemoryStore)
    end

    it "should allow moneta instances to be passed" do
      require 'moneta'
      require 'moneta/memory'
      APICache.store = Moneta::Memory.new
      expect(APICache.store).to be_kind_of(APICache::MonetaStore)
    end

    it "should raise an exception if anything else is passed" do
      expect(lambda {
        APICache.store = Class
      }).to raise_error(ArgumentError,
        'Please supply an instance of either a moneta store or a subclass of APICache::AbstractStore')
    end

    after :all do
      APICache.store = nil
    end
  end

  describe "get method" do

    context "when cache is mocked" do
      before :each do
        @api = instance_double(APICache::API, get: @api_data)
        @cache = instance_double(APICache::Cache, get: @cache_data, set: true)

        expect(APICache::API).to receive(:new).and_return(@api)
        expect(APICache::Cache).to receive(:new).and_return(@cache)
      end

      it "should fetch data from the cache if the state is :current" do
        expect(@cache).to receive(:state).and_return(:current)

        expect(APICache.get(@key)).to eq(@cache_data)
      end

      it "should make new request to API if the state is :refetch and store result in cache" do
        expect(@cache).to receive(:state).and_return(:refetch)

        expect(APICache.get(@key)).to eq(@api_data)
      end

      it "should return the cached value if the state is :refetch but the api is not accessible" do
        expect(@cache).to receive(:state).and_return(:refetch)
        expect(@api).to receive(:get).with(no_args).and_raise(APICache::CannotFetch)

        expect(APICache.get(@key)).to eq(@cache_data)
      end

      it "should make new request to API if the state is :invalid" do
        expect(@cache).to receive(:state).and_return(:invalid)

        expect(APICache.get(@key)).to eq(@api_data)
      end

      it "should raise CannotFetch if the api cannot fetch data and the cache state is :invalid" do
        expect(@cache).to receive(:state).and_return(:invalid)
        expect(@api).to receive(:get).with(no_args).and_raise(APICache::CannotFetch)

        expect(lambda {
          APICache.get(@key)
        }).to raise_error(APICache::CannotFetch)
      end

      it "should make new request to API if the state is :missing" do
        expect(@cache).to receive(:state).and_return(:missing)

        expect(APICache.get(@key)).to eq(@api_data)
      end

      it "should raise an exception if the api cannot fetch data and the cache state is :missing" do
        expect(@cache).to receive(:state).and_return(:missing)
        expect(@api).to receive(:get).with(no_args).and_raise(APICache::CannotFetch)

        expect(lambda {
          APICache.get(@key)
        }).to raise_error(APICache::CannotFetch)
      end
    end

    context "when cache is not mocked" do
      before(:each) do
        APICache.store = APICache::MemoryStore.new
        @api = instance_double(APICache::API, get: @api_data)
        APICache::API.stub(:new).and_return(@api)
        # expect(APICache::API).to receive(:new).and_return(@api)
      end

      it "should only fetch once" do
        expect(@api).to receive(:get).once
        APICache.get(@key)
        APICache.get(@key)
      end

      it "should refetch if deleted" do
        expect(@api).to receive(:get).twice
        APICache.get(@key)
        APICache.delete(@key)
        APICache.get(@key)
      end

    end

  end

end
