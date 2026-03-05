# Pin a message in a channel
# Usage: ruby scripts/pin_message.rb CHANNEL_ID TIMESTAMP

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TIMESTAMP")
timestamp  = ARGV[1] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TIMESTAMP")

data = slack_request(:post, '/pins.add', body: { channel: channel_id, timestamp: timestamp })

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

puts "Message pinned"
