require 'spec_helper'

describe DRbCached::Server do
  let(:server) { DRbCached::Server.new(options) }
  let(:options) { {} }

  describe "least-recently used deletion" do
    let(:options) { { cache_limit: 2 } }

    context "cache has reached the limited number objects" do
      it "removes the least-recently used entry when the adding a new entry" do
        server.write(:foo, 200)
        server.write(:bar, 300)
        server.write(:baz, 400)
        expect(server.exist?(:foo)).to eq false
      end
    end

  end

  describe "#full?" do
    let(:options) { { cache_limit: 2 } }
    it "returns true if the number of entries is greater than or equal to the limit" do
      server.write(:foo, 200)
      server.write(:bar, 300)
      expect(server.full?).to eq true
    end
  end

  context "updating access times" do
    context "reading an entry" do
      it "updates the access time" do
        server.write(:foo, 400)
        write_time = server.send(:last_access, :foo)
        sleep 0.01
        server.read(:foo)
        read_time = server.send(:last_access, :foo)
        expect(read_time > write_time).to eq true
      end
    end
  end
end
