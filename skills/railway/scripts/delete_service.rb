require_relative 'auth'

service_id = ARGV[0] or abort("Usage: ruby #{__FILE__} SERVICE_ID")

query = <<~GQL
  mutation serviceDelete($id: String!) {
    serviceDelete(id: $id)
  }
GQL

railway_query(query, { 'id' => service_id })

puts "Service deleted: #{service_id}"
