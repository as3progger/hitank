# Save the Stripe API key
# Usage: ruby scripts/save_token.rb API_KEY

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY")

# Validate by fetching balance
uri = URI('https://api.stripe.com/v1/balance')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid API key: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/stripe')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"
puts "Verified: API key is valid"
