require 'digest/sha1'

module DRbCached
  module ConsistentHash
    def self.hash(key)
      Digest::SHA1.hexdigest(key.to_s)[0..7]
    end
  end
end
