require_relative 'auth'

app_name   = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME MACHINE_ID")
machine_id = ARGV[1] or abort("Missing MACHINE_ID")

flyio_request(:post, "/v1/apps/#{app_name}/machines/#{machine_id}/start")

puts "Machine started: #{machine_id}"
