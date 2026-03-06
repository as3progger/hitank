require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME HOSTNAME")
hostname = ARGV[1] or abort("Missing HOSTNAME")

data = flyio_request(:get, "/v1/apps/#{app_name}/certificates/#{hostname}")

puts "Hostname:\t#{data['hostname']}"
puts "Check:\t#{data['check']}"
puts "Created:\t#{data['created_at']}"

acme = data['acme_certificate']
if acme
  puts "\nACME Certificate:"
  puts "  Status:\t#{acme['status']}"
  puts "  Issuer:\t#{acme['issuer']}"
end

custom = data['custom_certificate']
if custom
  puts "\nCustom Certificate:"
  puts "  Status:\t#{custom['status']}"
  puts "  Issuer:\t#{custom['issuer']}"
end

dns = data['dns_validation']
if dns
  puts "\nDNS Validation:"
  puts "  Status:\t#{dns['status']}"
  puts "  Target:\t#{dns['target']}"
end
