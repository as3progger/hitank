# Save the Shopify store config
# Usage: ruby scripts/save_token.rb STORE TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

store = ARGV[0] or abort("Usage: ruby #{__FILE__} STORE TOKEN")
token = ARGV[1] or abort("Missing TOKEN")

# Validate by fetching shop info
uri = URI("https://#{store}.myshopify.com/admin/api/2024-01/shop.json")
req = Net::HTTP::Get.new(uri)
req['X-Shopify-Access-Token'] = token
req['Content-Type']           = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code}"
end

config_dir  = File.expand_path('~/.config/shopify')
config_file = File.join(config_dir, 'config.json')

FileUtils.mkdir_p(config_dir)
File.write(config_file, JSON.pretty_generate({ 'store' => store, 'token' => token }))
File.chmod(0600, config_file)

data = JSON.parse(resp.body)
shop = data['shop']
puts "Config saved to #{config_file}"
puts "Verified: #{shop['name'] || store} (#{shop['domain'] || '-'})"
