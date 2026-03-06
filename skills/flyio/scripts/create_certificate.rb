require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME HOSTNAME")
hostname = ARGV[1] or abort("Missing HOSTNAME")

data = flyio_request(:post, "/v1/apps/#{app_name}/certificates/acme", body: { 'hostname' => hostname })

puts "Certificate requested for: #{hostname}"
puts "Check:\t#{data['check']}"

dns = data['dns_validation']
if dns
  puts "\nDNS Validation required:"
  puts "  Target:\t#{dns['target']}"
  puts "  Status:\t#{dns['status']}"
end
