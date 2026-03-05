# Search issues using JQL
# Usage: ruby scripts/issues.rb JQL [--max N]
# Example: ruby scripts/issues.rb 'project = MYPROJ AND status = "In Progress"'

require_relative 'auth'

jql = ARGV[0] or abort("Usage: ruby #{__FILE__} JQL [--max N]")

max_results = 20
if (idx = ARGV.index('--max')) && ARGV[idx + 1]
  max_results = ARGV[idx + 1].to_i
end

data = jira_request(:get, '/search', params: {
  'jql' => jql,
  'maxResults' => max_results,
  'fields' => 'summary,status,assignee,priority,issuetype'
})

(data['issues'] || []).each do |i|
  fields   = i['fields']
  status   = fields.dig('status', 'name') || '-'
  assignee = fields.dig('assignee', 'displayName') || 'Unassigned'
  priority = fields.dig('priority', 'name') || '-'
  type     = fields.dig('issuetype', 'name') || '-'
  puts "#{i['key']}\t[#{status}]\t#{type}\t#{priority}\t#{assignee}\t#{fields['summary']}"
end

puts "\nTotal: #{data['total'] || 0} issue(s)"
