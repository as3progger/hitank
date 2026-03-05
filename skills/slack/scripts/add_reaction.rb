# Add a reaction to a message
# Usage: ruby scripts/add_reaction.rb CHANNEL_ID TIMESTAMP EMOJI_NAME

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TIMESTAMP EMOJI_NAME")
timestamp  = ARGV[1] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TIMESTAMP EMOJI_NAME")
emoji_name = ARGV[2] or abort("Usage: ruby #{__FILE__} CHANNEL_ID TIMESTAMP EMOJI_NAME")

data = slack_request(:post, '/reactions.add', body: { channel: channel_id, timestamp: timestamp, name: emoji_name })

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

puts "Reaction :#{emoji_name}: added"
