# List users
# Usage: ruby scripts/users.rb [--limit N]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end

data = slack_request(:get, '/users.list', params: params)

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

(data['members'] || []).each do |u|
  puts "#{u['id']}\t#{u['name'] || '-'}\t#{u['real_name'] || '-'}\t#{u['is_bot'] ? 'bot' : 'user'}"
end
