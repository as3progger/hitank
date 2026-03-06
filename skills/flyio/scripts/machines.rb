require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME")

data = flyio_request(:get, "/v1/apps/#{app_name}/machines")

data.each do |m|
  region = m['region'] || ''
  state  = m['state'] || ''
  name   = m['name'] || ''
  image  = m.dig('config', 'image') || ''
  cpus   = m.dig('config', 'guest', 'cpus') || ''
  memory = m.dig('config', 'guest', 'memory_mb') || ''
  puts "#{m['id']}\t#{name}\t#{state}\t#{region}\t#{cpus}cpu/#{memory}MB\t#{image}"
end
