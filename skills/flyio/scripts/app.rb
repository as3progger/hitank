require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME")

data = flyio_request(:get, "/v1/apps/#{app_name}")

puts "Name:\t#{data['name']}"
puts "Status:\t#{data['status']}"
puts "Org:\t#{data.dig('organization', 'slug')}"
puts "ID:\t#{data['id']}"
