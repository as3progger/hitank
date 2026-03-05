# Save the Honeybadger API token
# Usage: ruby scripts/save_token.rb TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate by calling the API
uri = URI('https://app.honeybadger.io/v2/projects')
req = Net::HTTP::Get.new(uri)
req.basic_auth(token, '')
req['Accept'] = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/honeybadger')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"

projects = JSON.parse(resp.body)
count = projects.is_a?(Array) ? projects.length : projects.dig('results')&.length || 0
puts "Verified: #{count} project(s) accessible"
