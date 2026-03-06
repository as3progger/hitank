require_relative 'auth'

project_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID ENVIRONMENT_ID SERVICE_ID KEY VALUE")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")
service_id     = ARGV[2] or abort("Missing SERVICE_ID")
key            = ARGV[3] or abort("Missing KEY")
value          = ARGV[4] or abort("Missing VALUE")

query = <<~GQL
  mutation variableUpsert($input: VariableUpsertInput!) {
    variableUpsert(input: $input)
  }
GQL

input = {
  'projectId' => project_id,
  'environmentId' => environment_id,
  'serviceId' => service_id,
  'name' => key,
  'value' => value
}

railway_query(query, { 'input' => input })

puts "Variable set: #{key}"
