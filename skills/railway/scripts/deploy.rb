require_relative 'auth'

service_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} SERVICE_ID ENVIRONMENT_ID")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")

query = <<~GQL
  mutation serviceInstanceDeployV2($serviceId: String!, $environmentId: String!) {
    serviceInstanceDeployV2(serviceId: $serviceId, environmentId: $environmentId)
  }
GQL

data = railway_query(query, { 'serviceId' => service_id, 'environmentId' => environment_id })

puts "Deployment triggered: #{data['serviceInstanceDeployV2']}"
