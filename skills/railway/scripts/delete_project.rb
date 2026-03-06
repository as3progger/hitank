require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

query = <<~GQL
  mutation projectDelete($id: String!) {
    projectDelete(id: $id)
  }
GQL

railway_query(query, { 'id' => project_id })

puts "Project deleted: #{project_id}"
