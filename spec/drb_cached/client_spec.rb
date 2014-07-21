require 'spec_helper'

describe DRbCached::Client do
  let(:client) { DRbCached::Client.new("druby://localhost:5992") }

  before do
    start_server
  end

  after do
    stop_server
  end

  describe "#initialize" do
    context "no DRbCached::Server running" do
      it "raises an error" do
        expect{ DRbCached::Client.new("druby://localhost:54985") }.to raise_error
      end
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

      context "with an :expires_in option" do
        it "deletes the value after the expiration time" do
          client.write("foo", 500, expires_in: 0.01)
          sleep 0.01
          expect(client.read("foo")).to eq nil
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
