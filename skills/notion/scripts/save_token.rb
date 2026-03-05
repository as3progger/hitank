# Save the Notion integration token
# Usage: ruby scripts/save_token.rb TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate by fetching current user
uri = URI('https://api.notion.com/v1/users/me')
req = Net::HTTP::Get.new(uri)
req['Authorization']  = "Bearer #{token}"
req['Notion-Version'] = '2022-06-28'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/notion')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

data = JSON.parse(resp.body)
puts "Token saved to #{token_file}"
puts "Verified: #{data['name'] || data['type'] || 'token is valid'}"
