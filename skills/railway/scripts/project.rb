require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

query = <<~GQL
  query project($id: String!) {
    project(id: $id) {
      id
      name
      description
      createdAt
      updatedAt
      services {
        edges {
          node {
            id
            name
            icon
          }
        }
      }
      environments {
        edges {
          node {
            id
            name
          }
        }
      }
    }
  }
GQL

data = railway_query(query, { 'id' => project_id })
p = data['project']

puts "ID:\t#{p['id']}"
puts "Name:\t#{p['name']}"
puts "Desc:\t#{p['description']}"
puts "Created:\t#{p['createdAt']}"
puts "Updated:\t#{p['updatedAt']}"

services = (p.dig('services', 'edges') || []).map { |e| e['node'] }
unless services.empty?
  puts "\nServices:"
  services.each do |s|
    puts "  #{s['id']}\t#{s['name']}\t#{s['icon'] || ''}"
  end
end

envs = (p.dig('environments', 'edges') || []).map { |e| e['node'] }
unless envs.empty?
  puts "\nEnvironments:"
  envs.each do |e|
    puts "  #{e['id']}\t#{e['name']}"
  end
end
