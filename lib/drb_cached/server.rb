
module DRbCached

  class Server

    def initialize(host, options = {})
      @store = {}
      @options = options
      @host = host
      @cache_limit = @options[:cache_limit] || 10000
    end

    def start!
      DRb.start_service(@host, self)
      DRb.thread.join
    end

    def write(key,value, options = {})
      access_time = Time.now
      expires = options[:expires_in] ? access_time + options[:expires_in] : :never
      if full?
        delete_least_recently_used_entry
      end
      @store[key] = {value: value, expires_in: expires, access_time: access_time }
    end

    def read(key)
      temp = @store[key]
      return nil if temp.nil?
      temp[:access_time] = Time.now
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

    def full?
      @store.keys.count >= @cache_limit
    end

    private
    def should_expire?(entry, time)
      return false if entry[:expires_in] == :never
      entry[:expires_in] && entry[:expires_in] < time
    end

    def delete_least_recently_used_entry
      @store.delete least_recently_used_entry
    end

    def least_recently_used_entry
      @store.sort { |a, b| a[1][:access_time] <=> b[1][:access_time] }.first[0]
    end

    def last_access(entry)
      return @store[entry] && @store[entry][:access_time]
    end
  end
end
