require 'drb/drb'
module DrbStore
  class Client
    def initialize(address)
      @address = address
      @server = DRbObject.new_with_uri(@address)
      @server.status
    end

    def write(key, value)
      @server.write key, value
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
