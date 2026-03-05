# Check if Google Sheets setup is OK
# Usage: ruby scripts/check_setup.rb

require 'json'

key_file = File.expand_path('~/.config/gcloud/sheets-sa-key.json')

unless File.exist?(key_file)
  puts "SETUP_NEEDED"
  exit 0
end

kf = JSON.parse(File.read(key_file))
puts "OK"
puts "Service Account: #{kf['client_email']}"
