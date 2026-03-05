# List teams
# Usage: ruby scripts/teams.rb

require_relative 'auth'

query = <<~GQL
  query {
    teams {
      nodes {
        id name key description
      }
    }
  }
GQL

data = linear_query(query)

(data.dig('teams', 'nodes') || []).each do |t|
  puts "#{t['id']}\t#{t['name']}\t#{t['key']}\t#{t['description'] || '-'}"
end
