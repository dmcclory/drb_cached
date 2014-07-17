
module DRbCached

  class Server

    def initialize
      @store = {}
    end

    def start!
      DRb.start_service("druby://localhost:5992", self)
      DRb.thread.join
    end

    def write(key,value)
      @store[key] = value
    end

    def read(key)
      @store[key]
    end

    def exist?(key)
      @store.keys.include? key
    end

    def delete(key)
      return true unless @store.keys.include? key
      @store.delete key
    end

    def status
      "running"
    end
  end
end
