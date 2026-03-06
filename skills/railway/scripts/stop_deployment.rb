require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID")

query = <<~GQL
  mutation deploymentStop($id: String!) {
    deploymentStop(id: $id)
  }
GQL

railway_query(query, { 'id' => deployment_id })

puts "Deployment stopped: #{deployment_id}"
