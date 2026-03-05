# Check if Jira setup is OK
# Usage: ruby scripts/check_setup.rb

config_file = File.expand_path('~/.config/jira/config.json')

unless File.exist?(config_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
