# Resolve a fault
# Usage: ruby scripts/resolve.rb PROJECT_ID FAULT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID FAULT_ID")
fault_id   = ARGV[1] or abort("Missing FAULT_ID")

data = hb_request(:put, "/projects/#{project_id}/faults/#{fault_id}", body: { resolved: true })

puts "Fault ##{fault_id} resolved"
