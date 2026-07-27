require "rails_helper"

RSpec.describe BaldrickBuddy::ReleaseFetcher do
  describe ".purge_cache!" do
    it "clears the cached release" do
      Rails.cache.write(described_class::CACHE_KEY, "cached")

      described_class.purge_cache!

      expect(Rails.cache.read(described_class::CACHE_KEY)).to be_nil
    end
  end
end
