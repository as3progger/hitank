require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

query = <<~GQL
  query environments($projectId: String!) {
    environments(projectId: $projectId) {
      edges {
        node {
          id
          name
          createdAt
        }
      }
    }
  }
GQL

data = railway_query(query, { 'projectId' => project_id })

edges = data.dig('environments', 'edges') || []
edges.each do |e|
  n = e['node']
  puts "#{n['id']}\t#{n['name']}\t#{n['createdAt']}"
end
