# List cycles
# Usage: ruby scripts/cycles.rb [--team TEAM_ID]

require_relative 'auth'

filter = {}
if (idx = ARGV.index('--team')) && ARGV[idx + 1]
  filter['team'] = { 'id' => { 'eq' => ARGV[idx + 1] } }
end

query = <<~GQL
  query($filter: CycleFilter) {
    cycles(filter: $filter) {
      nodes {
        id number name startsAt endsAt
      }
    }
  }
GQL

data = linear_query(query, { 'filter' => filter.empty? ? nil : filter }.compact)

(data.dig('cycles', 'nodes') || []).each do |c|
  puts "#{c['id']}\t#{c['number']}\t#{c['name'] || '-'}\t#{c['startsAt'] || '-'}\t#{c['endsAt'] || '-'}"
end
