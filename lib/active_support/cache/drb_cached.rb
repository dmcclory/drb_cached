require 'forwardable'

module ActiveSupport
  Inflector.inflections(:en) do |inflect|
    inflect.acronym "DRb"
  end

  module Cache
    class DRbCached
      extend Forwardable
      def initialize
        @client = ::DRbCached::Client.new("druby://localhost:5992")
      end
      def_delegators :@client, :read, :write, :exist?, :fetch, :delete
    end
  end
end
