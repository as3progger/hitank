# List folders in a space
# Usage: ruby scripts/folders.rb SPACE_ID

require_relative 'auth'

space_id = ARGV[0] or abort("Usage: ruby #{__FILE__} SPACE_ID")

data = clickup_request(:get, "/space/#{space_id}/folder")

data['folders'].each do |f|
  puts "#{f['id']}\t#{f['name']}"
end
