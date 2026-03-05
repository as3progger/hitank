# Save the Jira config (domain, email, API token)
# Usage: ruby scripts/save_config.rb DOMAIN EMAIL TOKEN
# Example: ruby scripts/save_config.rb mycompany user@example.com API_TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'base64'
require 'fileutils'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN EMAIL TOKEN")
email  = ARGV[1] or abort("Missing EMAIL")
token  = ARGV[2] or abort("Missing TOKEN")

# Validate by calling the API
uri = URI("https://#{domain}.atlassian.net/rest/api/3/myself")
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Basic #{Base64.strict_encode64("#{email}:#{token}")}"
req['Accept']        = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid config: API returned #{resp.code}"
end

config_dir  = File.expand_path('~/.config/jira')
config_file = File.join(config_dir, 'config.json')

FileUtils.mkdir_p(config_dir)
File.write(config_file, JSON.pretty_generate({ 'domain' => domain, 'email' => email, 'token' => token }))
File.chmod(0600, config_file)

puts "Config saved to #{config_file}"

user = JSON.parse(resp.body)
puts "Verified: logged in as #{user['displayName']} (#{user['emailAddress']})"
