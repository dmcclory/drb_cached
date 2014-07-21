
module DRbCached

  class Server

    def initialize
      @store = {}
    end

    def start!
      DRb.start_service("druby://localhost:5992", self)
      DRb.thread.join
    end

    def write(key,value, options = {})
      expires = options[:expires_in] ? Time.now + options[:expires_in] : :never
      @store[key] = {value: value, expires_in: expires}
    end

    def read(key)
      temp = @store[key]
      return nil if temp.nil?
      if should_expire?(temp, Time.now)
        @store.delete(:key)
        return nil
      else
        @store[key][:value]
      end
    end

    def exist?(key)
      @store.keys.include? key
    end

    def delete(key)
      return true unless @store.keys.include? key
      @store.delete(key)[:value]
    end

    def status
      "running"
    end

    private
    def should_expire?(entry, time)
      return false if entry[:expires_in] == :never
      entry[:expires_in] && entry[:expires_in] < time
    end
  end
end
