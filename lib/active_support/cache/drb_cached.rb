require 'forwardable'

module ActiveSupport
  Inflector.inflections(:en) do |inflect|
    inflect.acronym "DRb"
  end

  module Cache
    class DRbCached
      extend Forwardable
      def initialize(*urls)
        puts args.inspect
        @client = ::DRbCached::Client.new(urls)
      end
      def_delegators :@client, :read, :write, :exist?, :fetch, :delete
    end
  end
end
