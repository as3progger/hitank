require_relative 'auth'

environment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ENVIRONMENT_ID")

query = <<~GQL
  mutation environmentDelete($id: String!) {
    environmentDelete(id: $id)
  }
GQL

railway_query(query, { 'id' => environment_id })

puts "Environment deleted: #{environment_id}"
