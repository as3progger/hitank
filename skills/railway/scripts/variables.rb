require_relative 'auth'

project_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID ENVIRONMENT_ID SERVICE_ID")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")
service_id     = ARGV[2] or abort("Missing SERVICE_ID")

query = <<~GQL
  query variables($projectId: String!, $environmentId: String!, $serviceId: String) {
    variables(projectId: $projectId, environmentId: $environmentId, serviceId: $serviceId)
  }
GQL

data = railway_query(query, {
  'projectId' => project_id,
  'environmentId' => environment_id,
  'serviceId' => service_id
})

vars = data['variables'] || {}
vars.each do |key, value|
  puts "#{key}\t#{value}"
end
