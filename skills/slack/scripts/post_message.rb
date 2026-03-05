# Post a message to a channel
# Usage: ruby scripts/post_message.rb CHANNEL_ID TEXT

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TEXT")
text       = ARGV[1] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TEXT")

data = slack_request(:post, '/chat.postMessage', body: { channel: channel_id, text: text })

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

puts "ts\t#{data['ts']}"
puts "channel\t#{data['channel']}"
