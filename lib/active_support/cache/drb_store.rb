require 'forwardable'

module ActiveSupport
  module Cache
    class DrbStore
      extend Forwardable
      def initialize
        @client = ::DrbStore::Client.new("druby://localhost:5992")
      end
      def_delegators :@client, :read, :write, :exist?, :fetch, :delete
    end
  end
end
