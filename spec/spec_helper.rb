require 'rspec'
require_relative '../lib/drb_cached'

def start_server
  DRb.start_service("druby://localhost:5992", DRbCached::Server.new("druby://localhost:5992"))
end

def stop_server
  DRb.stop_service
end
