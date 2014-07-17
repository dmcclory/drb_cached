require 'forwardable'

module ActiveSupport
  module Cache
    class DRbStore
      extend Forwardable
      def initialize
        @client = ::DRbStore::Client.new("druby://localhost:5992")
      end
      def_delegators :@client, :read, :write, :exist?, :fetch, :delete
    end
  end
end
