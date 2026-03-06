require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate token by listing apps
uri = URI('https://api.machines.dev/v1/apps?org_slug=personal')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code} — #{resp.body}"
end

token_dir  = File.expand_path('~/.config/flyio')
token_file = File.join(token_dir, 'token')
FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

data = JSON.parse(resp.body)
total = data['total_apps'] || 0

puts "Token saved to #{token_file}"
puts "Authenticated — #{total} app(s) found in personal org"
