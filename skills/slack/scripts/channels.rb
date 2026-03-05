# List channels
# Usage: ruby scripts/channels.rb [--limit N] [--types TYPE]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--types')) && ARGV[idx + 1]
  params['types'] = ARGV[idx + 1]
end

data = slack_request(:get, '/conversations.list', params: params)

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

(data['channels'] || []).each do |c|
  puts "#{c['id']}\t#{c['name'] || '-'}\t#{c['num_members'] || '-'}\t#{c['is_private'] ? 'private' : 'public'}"
end
