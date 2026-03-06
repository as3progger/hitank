require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID")

query = <<~GQL
  query deployment($id: String!) {
    deployment(id: $id) {
      id
      status
      createdAt
      url
      staticUrl
      canRedeploy
      canRollback
      meta
    }
  }
GQL

data = railway_query(query, { 'id' => deployment_id })
d = data['deployment']

puts "ID:\t#{d['id']}"
puts "Status:\t#{d['status']}"
puts "Created:\t#{d['createdAt']}"
puts "URL:\t#{d['url'] || d['staticUrl'] || 'none'}"
puts "Can Redeploy:\t#{d['canRedeploy']}"
puts "Can Rollback:\t#{d['canRollback']}"
