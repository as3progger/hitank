# Get issue details
# Usage: ruby scripts/issue.rb ISSUE_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID")

query = <<~GQL
  query($id: String!) {
    issue(id: $id) {
      id identifier title description state { name } assignee { name }
      priority estimate createdAt updatedAt
      team { name key } project { name } cycle { number name }
      labels { nodes { name } }
    }
  }
GQL

data = linear_query(query, { 'id' => id })
i = data['issue']

puts "id:\t#{i['identifier']}"
puts "title:\t#{i['title']}"
puts "state:\t#{i.dig('state', 'name') || '-'}"
puts "assignee:\t#{i.dig('assignee', 'name') || '-'}"
puts "priority:\t#{i['priority'] || '-'}"
puts "estimate:\t#{i['estimate'] || '-'}"
puts "team:\t#{i.dig('team', 'name') || '-'}"
puts "project:\t#{i.dig('project', 'name') || '-'}"
puts "cycle:\t#{i.dig('cycle', 'name') || '-'}"
puts "labels:\t#{(i.dig('labels', 'nodes') || []).map { |l| l['name'] }.join(', ')}"
puts "created:\t#{i['createdAt'] || '-'}"
puts "updated:\t#{i['updatedAt'] || '-'}"
puts "description:\t#{i['description'] || '-'}"
