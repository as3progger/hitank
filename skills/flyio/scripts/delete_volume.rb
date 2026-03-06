require_relative 'auth'

app_name  = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME VOLUME_ID")
volume_id = ARGV[1] or abort("Missing VOLUME_ID")

flyio_request(:delete, "/v1/apps/#{app_name}/volumes/#{volume_id}")

puts "Volume deleted: #{volume_id}"
