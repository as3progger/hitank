# List labels
# Usage: ruby scripts/labels.rb [--team TEAM_ID]

require_relative 'auth'

filter = {}
if (idx = ARGV.index('--team')) && ARGV[idx + 1]
  filter['team'] = { 'id' => { 'eq' => ARGV[idx + 1] } }
end

query = <<~GQL
  query($filter: IssueLabelFilter) {
    issueLabels(filter: $filter) {
      nodes {
        id name color
      }
    }
  }
GQL

data = linear_query(query, { 'filter' => filter.empty? ? nil : filter }.compact)

(data.dig('issueLabels', 'nodes') || []).each do |l|
  puts "#{l['id']}\t#{l['name']}\t#{l['color'] || '-'}"
end
