# Get fault details + recent notices
# Usage: ruby scripts/fault.rb PROJECT_ID FAULT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID FAULT_ID")
fault_id   = ARGV[1] or abort("Missing FAULT_ID")

fault = hb_request(:get, "/projects/#{project_id}/faults/#{fault_id}")

puts "Fault ##{fault['id']}"
puts "Class:    #{fault['klass']}"
puts "Message:  #{fault['message']}"
puts "Env:      #{fault['environment']}"
puts "Resolved: #{fault['resolved']}"
puts "Notices:  #{fault['notices_count']}"
puts "Created:  #{fault['created_at']}"
puts "Last:     #{fault['last_notice_at']}"
puts "URL:      #{fault['url']}"
puts ""

notices = hb_request(:get, "/projects/#{project_id}/faults/#{fault_id}/notices")
entries = notices.is_a?(Array) ? notices : notices['results'] || []

puts "Recent notices (#{entries.length}):"
entries.each do |n|
  puts "  #{n['id']}\t#{n['created_at']}\t#{n['message']}"
end
