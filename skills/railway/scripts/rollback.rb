require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID")

query = <<~GQL
  mutation deploymentRollback($id: String!) {
    deploymentRollback(id: $id)
  }
GQL

railway_query(query, { 'id' => deployment_id })

puts "Rolled back: #{deployment_id}"
