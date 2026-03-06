require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

query = <<~GQL
  query project($id: String!) {
    project(id: $id) {
      volumes {
        edges {
          node {
            id
            name
            createdAt
          }
        }
      }
    }
  }
GQL

data = railway_query(query, { 'id' => project_id })

edges = data.dig('project', 'volumes', 'edges') || []
edges.each do |e|
  v = e['node']
  puts "#{v['id']}\t#{v['name']}\t#{v['createdAt']}"
end
