# Get channel info
# Usage: ruby scripts/channel_info.rb CHANNEL_ID

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID")

data = slack_request(:get, '/conversations.info', params: { 'channel' => channel_id })

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

c = data['channel']
puts "id\t#{c['id']}"
puts "name\t#{c['name'] || '-'}"
puts "topic\t#{(c.dig('topic', 'value') || '-').gsub("\n", ' ')}"
puts "purpose\t#{(c.dig('purpose', 'value') || '-').gsub("\n", ' ')}"
puts "num_members\t#{c['num_members'] || '-'}"
puts "is_private\t#{c['is_private'] ? 'true' : 'false'}"
