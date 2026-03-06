require_relative 'auth'

app_name   = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME MACHINE_ID")
machine_id = ARGV[1] or abort("Missing MACHINE_ID")

data = flyio_request(:get, "/v1/apps/#{app_name}/machines/#{machine_id}")

puts "ID:\t#{data['id']}"
puts "Name:\t#{data['name']}"
puts "State:\t#{data['state']}"
puts "Region:\t#{data['region']}"
puts "Image:\t#{data.dig('config', 'image')}"
puts "CPUs:\t#{data.dig('config', 'guest', 'cpus')}"
puts "Memory:\t#{data.dig('config', 'guest', 'memory_mb')} MB"
puts "Created:\t#{data['created_at']}"
puts "Updated:\t#{data['updated_at']}"

checks = data.dig('checks') || []
unless checks.empty?
  puts "\nHealth Checks:"
  checks.each do |c|
    puts "  #{c['name']}\t#{c['status']}"
  end
end

events = data['events'] || []
unless events.empty?
  puts "\nRecent Events:"
  events.last(5).each do |e|
    puts "  #{e['timestamp']}\t#{e['type']}\t#{e['status']}"
  end
end
