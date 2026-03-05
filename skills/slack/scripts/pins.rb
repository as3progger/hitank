# List pinned messages in a channel
# Usage: ruby scripts/pins.rb CHANNEL_ID

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID")

data = slack_request(:get, '/pins.list', params: { 'channel' => channel_id })

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

(data['items'] || []).each do |item|
  type = item['type'] || '-'
  text = (item.dig('message', 'text') || '-').gsub("\n", ' ')
  text = text[0, 80] + '...' if text.length > 80
  puts "#{type}\t#{text}"
end
