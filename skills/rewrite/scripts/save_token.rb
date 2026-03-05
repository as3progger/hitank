# Save the Rewrite API token
# Usage: ruby scripts/save_token.rb TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate by sending a test request (list projects)
uri = URI('https://api.rewritetoday.com/v1/messages')
req = Net::HTTP::Post.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json'
req.body = JSON.generate({ 'to' => '+0000000000', 'message' => 'test' })
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

# 401/403 means invalid token, other errors (like validation) mean token is valid
if resp.code == '401' || resp.code == '403'
  abort "Invalid token: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/rewrite')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"
puts "Verified: token is valid"
