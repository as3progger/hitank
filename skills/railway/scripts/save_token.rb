require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate token by querying current user
uri = URI('https://backboard.railway.com/graphql/v2')
req = Net::HTTP::Post.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json'
req.body = JSON.generate({ 'query' => 'query { me { id name email } }' })
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code} — #{resp.body}"
end

data = JSON.parse(resp.body)
if data['errors']
  abort "Invalid token: #{data['errors'].map { |e| e['message'] }.join(', ')}"
end

me = data.dig('data', 'me')

token_dir  = File.expand_path('~/.config/railway')
token_file = File.join(token_dir, 'token')
FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"
puts "Authenticated as: #{me['name']} (#{me['email']})"
