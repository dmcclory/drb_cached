require 'spec_helper'

describe DrbStore::Client do
  let(:client) { DrbStore::Client.new("druby://localhost:5992") }

  before do
    start_server
  end

  after do
    stop_server
  end

  describe "#initialize" do
    context "no DrbStore::Server running" do
      it "raises an error"
    end
  end

  context "implements ActiveSupport::Cache::Store's interface" do
    describe "#write" do
      it "can read and write objects" do
        client.write("foo", 42)
        expect(client.read("foo")).to eq 42
      end

      context "reading a non-existent key" do
        it "returns nil" do
          expect(client.read("missing")).to eq nil
        end
      end
    end

    describe "#exist?" do
      it "returns true if a key has a value in the store" do
        client.write("hmm", 42)
        expect(client.exist? "hmm").to eq true
      end

      it "returns false if a key is not present in the store" do
        expect(client.exist? "hmm").to eq false
        expect(client.exist? "never-written").to eq false
      end
    end

    describe "#fetch" do
      context "when the value is present" do
        it "returns the stored value" do
          client.write("hmm", 42)
          client.fetch("hmm") do
            400
          end
          expect(client.read("hmm")).to eq 42
        end
        it "does not execute the passed block" do
          client.write("hmm", 42)
          expect {
            client.fetch("hmm") do
              fail "foo"
            end
          }.not_to raise_error
        end
      end

      context "when there is no value" do
        it "stores the value of the block" do
          client.fetch("missing") do
            400
          end
          expect(client.read("missing")).to eq 400
        end
      end
    end

    describe "#delete" do
      it "removes values from the store" do
        client.write("hmm", 23)
        client.delete("hmm")
        expect(client.read("hmm")).to eq nil
      end
      context "key is not present in the store" do
        it "returns true" do
          expect(client.delete("hmm")).to eq true
        end
      end
    end
  end
end
