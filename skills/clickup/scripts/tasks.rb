# List tasks in a list
# Usage: ruby scripts/tasks.rb LIST_ID [--page N] [--include-closed]

require_relative 'auth'

list_id = ARGV[0] or abort("Usage: ruby #{__FILE__} LIST_ID [--page N] [--include-closed]")

params = {}
if (idx = ARGV.index('--page')) && ARGV[idx + 1]
  params['page'] = ARGV[idx + 1]
end
params['include_closed'] = 'true' if ARGV.include?('--include-closed')

data = clickup_request(:get, "/list/#{list_id}/task", params: params)

data['tasks'].each do |t|
  status   = t.dig('status', 'status') || '-'
  priority = t.dig('priority', 'priority') || 'none'
  puts "#{t['id']}\t[#{status}]\t(P:#{priority})\t#{t['name']}"
end
