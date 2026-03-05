# Search messages across the workspace
# Usage: ruby scripts/search_messages.rb QUERY [--count N]
# Note: Requires the search:read Bot Token scope

require_relative 'auth'

query = ARGV[0] or abort("Usage: ruby #{__FILE__} QUERY [--count N]")

params = { 'query' => query }
if (idx = ARGV.index('--count')) && ARGV[idx + 1]
  params['count'] = ARGV[idx + 1]
end

data = slack_request(:get, '/search.messages', params: params)

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

matches = data.dig('messages', 'matches') || []
matches.each do |m|
  channel_name = m.dig('channel', 'name') || '-'
  username     = m['username'] || '-'
  text         = (m['text'] || '').gsub("\n", ' ')
  text         = text[0, 80] + '...' if text.length > 80
  puts "#{channel_name}\t#{username}\t#{text}"
end
