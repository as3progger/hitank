require_relative 'auth'

project_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID ENVIRONMENT_ID SERVICE_ID KEY")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")
service_id     = ARGV[2] or abort("Missing SERVICE_ID")
key            = ARGV[3] or abort("Missing KEY")

query = <<~GQL
  mutation variableDelete($input: VariableDeleteInput!) {
    variableDelete(input: $input)
  }
GQL

input = {
  'projectId' => project_id,
  'environmentId' => environment_id,
  'serviceId' => service_id,
  'name' => key
}

railway_query(query, { 'input' => input })

puts "Variable deleted: #{key}"
