# List time entries for a workspace
# Usage: ruby scripts/time_entries.rb TEAM_ID [--start MS] [--end MS]

require_relative 'auth'

team_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TEAM_ID [--start MS] [--end MS]")

params = {}
if (idx = ARGV.index('--start')) && ARGV[idx + 1]
  params['start_date'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--end')) && ARGV[idx + 1]
  params['end_date'] = ARGV[idx + 1]
end

data = clickup_request(:get, "/team/#{team_id}/time_entries", params: params)

(data['data'] || []).each do |e|
  dur_min = (e['duration'].to_i / 60000)
  task = e.dig('task', 'name') || 'no task'
  puts "#{e['id']}\t#{dur_min}m\t#{task}\t#{e['description'] || ''}"
end
