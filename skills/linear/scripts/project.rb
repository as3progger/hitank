# Get project details
# Usage: ruby scripts/project.rb PROJECT_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

query = <<~GQL
  query($id: String!) {
    project(id: $id) {
      id name description state progress startDate targetDate
      teams { nodes { name } }
    }
  }
GQL

data = linear_query(query, { 'id' => id })
p = data['project']

puts "id:\t#{p['id']}"
puts "name:\t#{p['name']}"
puts "state:\t#{p['state'] || '-'}"
puts "progress:\t#{p['progress'] || '-'}"
puts "startDate:\t#{p['startDate'] || '-'}"
puts "targetDate:\t#{p['targetDate'] || '-'}"
puts "teams:\t#{(p.dig('teams', 'nodes') || []).map { |t| t['name'] }.join(', ')}"
puts "description:\t#{p['description'] || '-'}"
