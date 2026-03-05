# Check if Honeybadger setup is OK
# Usage: ruby scripts/check_setup.rb

token_file = File.expand_path('~/.config/honeybadger/token')

unless File.exist?(token_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
