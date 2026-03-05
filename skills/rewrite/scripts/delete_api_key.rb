# Delete an API key
# Usage: ruby scripts/delete_api_key.rb PROJECT_ID API_KEY

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID API_KEY")
api_key    = ARGV[1] or abort("Missing API_KEY")

rewrite_request(:delete, "/projects/#{project_id}/api-keys/#{api_key}")

puts "Deleted API key: #{api_key}"
