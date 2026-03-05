# Search tasks by name across a workspace
# Usage: ruby scripts/search_tasks.rb TEAM_ID QUERY [--include-closed]

require_relative 'auth'

team_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TEAM_ID QUERY [--include-closed]")
query   = ARGV[1] or abort("Missing QUERY")

params = { 'search' => query, 'subtasks' => 'true' }
params['include_closed'] = 'true' if ARGV.include?('--include-closed')

data = clickup_request(:get, "/team/#{team_id}/task", params: params)

(data['tasks'] || []).each do |t|
  status = t.dig('status', 'status') || '-'
  puts "#{t['id']}\t[#{status}]\t#{t['name']}"
end
