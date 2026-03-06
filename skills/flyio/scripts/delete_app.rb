require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME")

flyio_request(:delete, "/v1/apps/#{app_name}")

puts "App deleted: #{app_name}"
