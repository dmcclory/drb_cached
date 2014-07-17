
module DrbStore

  class Server

    def initialize
      @store = {}
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
  end
end
