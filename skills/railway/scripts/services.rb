require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

query = <<~GQL
  query project($id: String!) {
    project(id: $id) {
      services {
        edges {
          node {
            id
            name
            icon
            createdAt
          }
        }
      }
    }
  }
GQL

data = railway_query(query, { 'id' => project_id })

edges = data.dig('project', 'services', 'edges') || []
edges.each do |e|
  s = e['node']
  puts "#{s['id']}\t#{s['name']}\t#{s['icon'] || ''}\t#{s['createdAt']}"
end
