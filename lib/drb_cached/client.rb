require 'drb/drb'
module DRbCached
  class Client
    def initialize(addresses)
      @addresses = Array[addresses]
      @servers = @addresses.map { |address| DRbObject.new_with_uri(address) }
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
      @servers.first
    end
  end
end
