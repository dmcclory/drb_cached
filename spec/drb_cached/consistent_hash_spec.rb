require 'spec_helper'

describe DRbCached::ConsistentHash do
  describe ".hash" do
    it "hashes a key man" do
      x = DRbCached::ConsistentHash.hash("foo")
      expect(x.length).to eq 8
    end
  end
end
