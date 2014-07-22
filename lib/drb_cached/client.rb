require 'drb/drb'
module DRbCached
  class Client
    def initialize(addresses)
      @addresses = Array[addresses]
      @address = @addresses.first
      @server = DRbObject.new_with_uri(@address)
      @server.status
    end

    def write(key, value, options = {})
      @server.write key, value, options
    end

    def read(key)
      @server.read key
    end

    def exist?(key)
      @server.exist? key
    end

    def fetch(key, &block)
      if @server.exist?(key)
        @server.read(key)
      else
        @server.write key, block.call
      end
    end

    def delete(key)
      @server.delete key
    end
  end
end
