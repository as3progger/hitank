require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME")

data = flyio_request(:get, "/v1/apps/#{app_name}/certificates")

(data || []).each do |c|
  hostname = c['hostname'] || ''
  check    = c['check'] || ''
  puts "#{hostname}\t#{check}\t#{c['created_at']}"
end
