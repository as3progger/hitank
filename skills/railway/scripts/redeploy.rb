require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID")

query = <<~GQL
  mutation deploymentRedeploy($id: String!) {
    deploymentRedeploy(id: $id) {
      id
      status
    }
  }
GQL

data = railway_query(query, { 'id' => deployment_id })
d = data['deploymentRedeploy']

puts "Redeployed: #{d['id']}\t#{d['status']}"
