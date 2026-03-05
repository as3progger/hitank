# Create an API key for a project
# Usage: ruby scripts/create_api_key.rb PROJECT_ID [NAME]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [NAME]")

body = {}
body['name'] = ARGV[1] if ARGV[1]

data = rewrite_request(:post, "/projects/#{project_id}/api-keys", body: body)

k = data['data'] || data
puts "Created API key: #{k['key'] || k['id']}"
puts "name:\t#{k['name'] || '-'}"
puts "IMPORTANT: Save this key now. It won't be shown again."
