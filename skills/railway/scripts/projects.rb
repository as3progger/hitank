require_relative 'auth'

query = <<~GQL
  query {
    projects {
      edges {
        node {
          id
          name
          description
          createdAt
          updatedAt
        }
      }
    }
  }
GQL

data = railway_query(query)

edges = data.dig('projects', 'edges') || []
edges.each do |e|
  n = e['node']
  desc = (n['description'] || '')[0..60]
  puts "#{n['id']}\t#{n['name']}\t#{desc}\t#{n['updatedAt']}"
end
