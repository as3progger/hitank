require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME")

data = flyio_request(:get, "/v1/apps/#{app_name}/volumes")

data.each do |v|
  puts "#{v['id']}\t#{v['name']}\t#{v['state']}\t#{v['region']}\t#{v['size_gb']}GB\t#{v['attached_machine_id'] || 'detached'}"
end
