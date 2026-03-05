# List issues
# Usage: ruby scripts/issues.rb [--team TEAM_KEY] [--state STATE] [--limit N]

require_relative 'auth'

limit = 50
filter = {}
if (idx = ARGV.index('--team')) && ARGV[idx + 1]
  filter['team'] = { 'key' => { 'eq' => ARGV[idx + 1] } }
end
if (idx = ARGV.index('--state')) && ARGV[idx + 1]
  filter['state'] = { 'name' => { 'eq' => ARGV[idx + 1] } }
end
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  limit = ARGV[idx + 1].to_i
end

query = <<~GQL
  query($first: Int, $filter: IssueFilter) {
    issues(first: $first, filter: $filter) {
      nodes {
        id identifier title state { name } assignee { name } priority createdAt
      }
    }
  }
GQL

data = linear_query(query, { 'first' => limit, 'filter' => filter.empty? ? nil : filter }.compact)

(data.dig('issues', 'nodes') || []).each do |i|
  state    = i.dig('state', 'name') || '-'
  assignee = i.dig('assignee', 'name') || '-'
  puts "#{i['identifier']}\t#{i['title']}\t#{state}\t#{assignee}\t#{i['priority'] || '-'}"
end
