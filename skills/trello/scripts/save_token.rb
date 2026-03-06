require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

key   = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY TOKEN")
token = ARGV[1] or abort("Usage: ruby #{__FILE__} API_KEY TOKEN")

# Validate credentials by fetching current member
uri = URI("https://api.trello.com/1/members/me?key=#{key}&token=#{token}&fields=id,username,fullName")
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(Net::HTTP::Get.new(uri)) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code} — #{resp.body}"
end

member = JSON.parse(resp.body)

credentials_dir  = File.expand_path('~/.config/trello')
credentials_file = File.join(credentials_dir, 'credentials.json')
FileUtils.mkdir_p(credentials_dir)
File.write(credentials_file, JSON.pretty_generate({ 'key' => key, 'token' => token }))
File.chmod(0600, credentials_file)

puts "Credentials saved to #{credentials_file}"
puts "Authenticated as: #{member['fullName']} (@#{member['username']})"
