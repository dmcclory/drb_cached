require 'spec_helper'

describe DRbCached::NodeSet do

  let(:count)    { 10 }
  let(:node_set) { DRbCached::NodeSet.new(count) }

  describe "#initialize" do
    it "is a bunch of nodes" do
      expect(node_set.length).to eq 10
    end

    it "stores the nodes in order sorted by keys" do
      node_set.nodes.each_cons(2) do |a, b|
        expect(a.key).to be <= b.key
      end
    end

    context "adding virtual nodes" do
      let(:virtual_node_count) { 10 }
      let(:node_set) { DRbCached::NodeSet.new(count, virtual_node_count) }
      it "adds multiple points for each node" do
        expect(node_set.length).to eq 100
      end
    end
  end

  describe "#node_for" do
    it "returns the first node if the value of a hash key is smaller than the first node's key" do
      expect(node_set.node_for("00000000")).to eq node_set.first
    end

    it "returns the first node if a key's hash is greater than the hash of the lasts node" do
      expect(node_set.node_for("ffffffff")).to eq node_set.first
    end
  end

  describe "#add" do
    let(:key) { 11 }
    it "inserts a new node into the ring" do
      node_set.add(key)
      expect(node_set.length).to eq 11

      node_set.nodes.each_cons(2) do |a, b|
        expect(a.key).to be <= b.key
      end
    end

    context "multiple virtual nodes" do
      let(:virtual_node_count) { 10 }
      let(:node_set) { DRbCached::NodeSet.new(count, virtual_node_count) }

      it "adds multiple virtual nodes for the new node" do
        node_set.add(11)
        expect(node_set.length).to eq 110
      end
    end
  end

  describe "#remove" do
    let(:node) { 5 }
    it "removes the node from the node_set" do
      node_set.remove(node)
      expect(node_set.length).to eq 9

      node_set.nodes.each_cons(2) do |a, b|
        expect(a.key).to be <= b.key
      end
    end

    context "multiple virtual nodes" do
      let(:virtual_node_count) { 10 }
      let(:node_set) { DRbCached::NodeSet.new(count, virtual_node_count) }

      it "removes each virtual node for the target node" do
        node_set.remove(node)
        expect(node_set.length).to eq 90
      end
    end
  end
end
