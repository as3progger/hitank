# List tags in a space
# Usage: ruby scripts/tags.rb SPACE_ID

require_relative 'auth'

space_id = ARGV[0] or abort("Usage: ruby #{__FILE__} SPACE_ID")

data = clickup_request(:get, "/space/#{space_id}/tag")

(data['tags'] || []).each do |t|
  puts t['name']
end
