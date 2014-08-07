require 'spec_helper'

describe "Consistent Hashing for multiple servers" do
  let(:address_1) { "druby://localhost:5990" }
  let(:address_2) { "druby://localhost:5991" }
  let(:server_1)  { DRbCached::Server.new(address_1) }
  let(:server_2)  { DRbCached::Server.new(address_2) }
  let(:client)    { DRbCached::Client.new([address_1, address_2]) }


  before do
    server_1.start
    server_2.start
  end

  context "writing a key" do
    let(:magic_string_1) { "the key to server_1." }
    let(:magic_string_2) { "the key to server_2." }

    it "sends the write to one DRb server, based on the sha of it's key" do
      client.write(magic_string_1, "this is cool")

      expect(server_1.stats[:count]).to eq 1
      expect(server_2.stats[:count]).to eq 0
      expect(server_1.read(magic_string_1)).to eq "this is cool"

      client.write(magic_string_2, "this is on another node")
      expect(server_1.stats[:count]).to eq 1
      expect(server_2.stats[:count]).to eq 1
      expect(server_2.read(magic_string_2)).to eq "this is on another node"
    end
  end

  context "reading a key" do
    it "sends the read to one DRb server, based on the sha of it's key" do
      client.write("foo", "this is cool")
      result = client.read("foo")
      expect(result).to eq "this is cool"
      client.write("foobar", "this is from another server")
      result = client.read("foobar")
      expect(result).to eq "this is from another server"
    end
  end
end
