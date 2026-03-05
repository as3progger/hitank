# Save the Linear API key
# Usage: ruby scripts/save_token.rb API_KEY

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY")

# Validate by querying viewer
uri = URI('https://api.linear.app/graphql')
req = Net::HTTP::Post.new(uri)
req['Authorization'] = token
req['Content-Type']  = 'application/json'
req.body = JSON.generate({ 'query' => '{ viewer { id name email } }' })
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

data = JSON.parse(resp.body)
if data['errors'] || !data.dig('data', 'viewer')
  abort "Invalid API key: #{data['errors']&.first&.dig('message') || 'unknown error'}"
end

token_dir  = File.expand_path('~/.config/linear')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

viewer = data['data']['viewer']
puts "Token saved to #{token_file}"
puts "Verified: #{viewer['name']} (#{viewer['email']})"
