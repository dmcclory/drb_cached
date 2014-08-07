module DRbCached
  class Node
    attr_reader :name
    def initialize(name, virtual_node_count = 0)
      @name = name
      @virtual_node_count = virtual_node_count
      @key = ConsistentHash.hash("#{@name}-#{@virtual_node_count}")
    end

    def key
      @key.to_i(16)
    end

    def ==(node)
      key == node.key
    end
  end

  class NodeSet
    attr_reader :nodes

    def initialize(nodes, virtual_node_count = 1)
      @virtual_node_count = virtual_node_count
      @nodes = nodes.map do |n|
        virtual_node_count.times.map do |vn|
          Node.new(n,vn)
        end
      end.flatten.sort { |a, b| a.key <=> b.key }
    end

    def length
      @nodes.length
    end

    def node_for(hash)
      target = @nodes.select { |node| node.key > hash.to_i(16) }.first
      target.nil? ? @nodes.first.name : target.name
    end

    def add(node_name)
      @virtual_node_count.times.each do |vn|
        @nodes.push Node.new(node_name, vn)
      end
      @nodes.sort! { |a, b| a.key <=> b.key }
    end

    def remove(node_name)
      @virtual_node_count.times.each do |vn|
        node = Node.new(node_name, vn)
        @nodes.delete node
      end
    end

    def first
      @nodes.first.name
    end

    def last
      @nodes.last.name
    end
  end
end
