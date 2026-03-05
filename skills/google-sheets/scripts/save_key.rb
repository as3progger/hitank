# Save the Service Account JSON key
# Usage: ruby scripts/save_key.rb 'JSON_CONTENT'

require 'json'
require 'fileutils'

json_content = ARGV[0] or abort("Usage: ruby #{__FILE__} 'JSON_CONTENT'")

# Validate JSON
begin
  kf = JSON.parse(json_content)
rescue JSON::ParserError => e
  abort "Invalid JSON: #{e.message}"
end

unless kf['client_email'] && kf['private_key']
  abort "Invalid Service Account key: missing client_email or private_key"
end

key_dir = File.expand_path('~/.config/gcloud')
key_file = File.join(key_dir, 'sheets-sa-key.json')

FileUtils.mkdir_p(key_dir)
File.write(key_file, JSON.pretty_generate(kf))
File.chmod(0600, key_file)

puts "Key saved to #{key_file}"
puts "Service Account: #{kf['client_email']}"
puts ""
puts "Now share your spreadsheet with this email as Editor."
