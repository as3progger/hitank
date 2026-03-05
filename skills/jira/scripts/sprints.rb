# List sprints for a board
# Usage: ruby scripts/sprints.rb BOARD_ID [--state STATE]
# States: active, closed, future

require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID [--state STATE]")

params = {}
if (idx = ARGV.index('--state')) && ARGV[idx + 1]
  params['state'] = ARGV[idx + 1]
end

data = jira_request(:get, "/board/#{board_id}/sprint", agile: true, params: params)

(data['values'] || []).each do |s|
  state     = s['state'] || '-'
  start_d   = s['startDate'] || '-'
  end_d     = s['endDate'] || '-'
  puts "#{s['id']}\t#{s['name']}\t#{state}\t#{start_d}\t#{end_d}"
end
