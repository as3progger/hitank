require_relative 'auth'

service_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} SERVICE_ID ENVIRONMENT_ID")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")

query = <<~GQL
  query serviceInstance($serviceId: String!, $environmentId: String!) {
    serviceInstance(serviceId: $serviceId, environmentId: $environmentId) {
      id
      serviceName
      startCommand
      buildCommand
      rootDirectory
      healthcheckPath
      region
      numReplicas
      restartPolicyType
      restartPolicyMaxRetries
      latestDeployment {
        id
        status
        createdAt
      }
    }
  }
GQL

data = railway_query(query, { 'serviceId' => service_id, 'environmentId' => environment_id })
s = data['serviceInstance']

puts "ID:\t#{s['id']}"
puts "Name:\t#{s['serviceName']}"
puts "Region:\t#{s['region']}"
puts "Replicas:\t#{s['numReplicas']}"
puts "Build Cmd:\t#{s['buildCommand']}"
puts "Start Cmd:\t#{s['startCommand']}"
puts "Root Dir:\t#{s['rootDirectory']}"
puts "Health Check:\t#{s['healthcheckPath']}"
puts "Restart Policy:\t#{s['restartPolicyType']} (max #{s['restartPolicyMaxRetries']})"

dep = s['latestDeployment']
if dep
  puts "\nLatest Deployment:"
  puts "  ID:\t#{dep['id']}"
  puts "  Status:\t#{dep['status']}"
  puts "  Created:\t#{dep['createdAt']}"
end
