require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME --name NAME --region REGION --size GB")

body = {}

if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
else
  abort "Missing --name"
end
if (idx = ARGV.index('--region')) && ARGV[idx + 1]
  body['region'] = ARGV[idx + 1]
else
  abort "Missing --region"
end
if (idx = ARGV.index('--size')) && ARGV[idx + 1]
  body['size_gb'] = ARGV[idx + 1].to_i
else
  body['size_gb'] = 1
end

data = flyio_request(:post, "/v1/apps/#{app_name}/volumes", body: body)

puts "Volume created: #{data['id']}\t#{data['name']}\t#{data['region']}\t#{data['size_gb']}GB"
