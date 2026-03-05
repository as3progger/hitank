# Save the Slack Bot token
# Usage: ruby scripts/save_token.rb BOT_TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} BOT_TOKEN")

# Validate by calling auth.test
uri = URI('https://slack.com/api/auth.test')
req = Net::HTTP::Post.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json; charset=utf-8'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

data = JSON.parse(resp.body)
unless data['ok']
  abort "Invalid token: #{data['error'] || 'unknown error'}"
end

token_dir  = File.expand_path('~/.config/slack')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"
puts "Verified: authenticated as #{data['user'] || '-'} in team #{data['team'] || '-'}"
