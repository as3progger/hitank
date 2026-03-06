require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME [--org ORG_SLUG]")

body = { 'app_name' => app_name }

if (idx = ARGV.index('--org')) && ARGV[idx + 1]
  body['org_slug'] = ARGV[idx + 1]
end

data = flyio_request(:post, '/v1/apps', body: body)

puts "App created: #{data['name']}\t#{data['status']}\t#{data.dig('organization', 'slug')}"
