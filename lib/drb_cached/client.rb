require 'drb/drb'
module DRbCached
  class Client
    def initialize(addresses)
      @addresses = Array[addresses].flatten
      @servers = @addresses.map { |address| DRbObject.new_with_uri(address) }
      @node_set = NodeSet.new(@servers, 200)
    end

    def write(key, value, options = {})
      server = server_for(key)
      server.write key, value, options
    end

    def read(key)
      server = server_for(key)
      server.read key
    end

    def exist?(key)
      server = server_for(key)
      server.exist? key
    end

    def fetch(key, &block)
      server = server_for(key)
      if server.exist?(key)
        server.read(key)
      else
        server.write key, block.call
      end
    end

    def delete(key)
      server = server_for(key)
      server.delete key
    end

    def server_for(key)
      hash = ConsistentHash.hash(key)
      @node_set.node_for(hash)
    end
  end
end
