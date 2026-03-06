require 'json'

credentials_file = File.expand_path('~/.config/trello/credentials.json')

unless File.exist?(credentials_file)
  puts "SETUP_NEEDED"
  exit 0
end

creds = JSON.parse(File.read(credentials_file))
unless creds['key'] && creds['token']
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
