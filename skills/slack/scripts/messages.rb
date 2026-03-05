# Get message history for a channel
# Usage: ruby scripts/messages.rb CHANNEL_ID [--limit N]

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID [--limit N]")

params = { 'channel' => channel_id }
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end

data = slack_request(:get, '/conversations.history', params: params)

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

(data['messages'] || []).each do |m|
  text = (m['text'] || '').gsub("\n", ' ')
  text = text[0, 80] + '...' if text.length > 80
  puts "#{m['ts']}\t#{m['user'] || '-'}\t#{text}"
end
