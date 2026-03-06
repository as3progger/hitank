require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME --image IMAGE [--region REGION] [--cpus N] [--memory MB] [--name NAME]")

body = { 'config' => { 'guest' => {} } }

if (idx = ARGV.index('--image')) && ARGV[idx + 1]
  body['config']['image'] = ARGV[idx + 1]
else
  abort "Missing --image"
end

if (idx = ARGV.index('--region')) && ARGV[idx + 1]
  body['region'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--cpus')) && ARGV[idx + 1]
  body['config']['guest']['cpus'] = ARGV[idx + 1].to_i
end
if (idx = ARGV.index('--memory')) && ARGV[idx + 1]
  body['config']['guest']['memory_mb'] = ARGV[idx + 1].to_i
end
if (idx = ARGV.index('--env')) && ARGV[idx + 1]
  env = {}
  ARGV[idx + 1].split(',').each do |pair|
    k, v = pair.split('=', 2)
    env[k] = v
  end
  body['config']['env'] = env
end

data = flyio_request(:post, "/v1/apps/#{app_name}/machines", body: body)

puts "Machine created: #{data['id']}\t#{data['name']}\t#{data['state']}\t#{data['region']}"
