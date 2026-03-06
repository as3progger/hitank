require_relative 'auth'

app_name   = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME MACHINE_ID [--image IMAGE] [--cpus N] [--memory MB]")
machine_id = ARGV[1] or abort("Missing MACHINE_ID")

# Fetch current config
current = flyio_request(:get, "/v1/apps/#{app_name}/machines/#{machine_id}")
config = current['config'] || {}

if (idx = ARGV.index('--image')) && ARGV[idx + 1]
  config['image'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--cpus')) && ARGV[idx + 1]
  config['guest'] ||= {}
  config['guest']['cpus'] = ARGV[idx + 1].to_i
end
if (idx = ARGV.index('--memory')) && ARGV[idx + 1]
  config['guest'] ||= {}
  config['guest']['memory_mb'] = ARGV[idx + 1].to_i
end

data = flyio_request(:post, "/v1/apps/#{app_name}/machines/#{machine_id}", body: { 'config' => config })

puts "Machine updated: #{data['id']}\t#{data['name']}\t#{data['state']}"
