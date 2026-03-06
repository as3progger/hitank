require_relative 'auth'

app_name  = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME VOLUME_ID")
volume_id = ARGV[1] or abort("Missing VOLUME_ID")

data = flyio_request(:get, "/v1/apps/#{app_name}/volumes/#{volume_id}")

puts "ID:\t#{data['id']}"
puts "Name:\t#{data['name']}"
puts "State:\t#{data['state']}"
puts "Region:\t#{data['region']}"
puts "Size:\t#{data['size_gb']} GB"
puts "Encrypted:\t#{data['encrypted']}"
puts "Machine:\t#{data['attached_machine_id'] || 'detached'}"
puts "Created:\t#{data['created_at']}"
