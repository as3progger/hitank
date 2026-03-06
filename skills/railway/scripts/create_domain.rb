require_relative 'auth'

service_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} SERVICE_ID ENVIRONMENT_ID [--port PORT]")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")

input = { 'serviceId' => service_id, 'environmentId' => environment_id }

if (idx = ARGV.index('--port')) && ARGV[idx + 1]
  input['targetPort'] = ARGV[idx + 1].to_i
end

query = <<~GQL
  mutation serviceDomainCreate($input: ServiceDomainCreateInput!) {
    serviceDomainCreate(input: $input) {
      id
      domain
    }
  }
GQL

data = railway_query(query, { 'input' => input })
d = data['serviceDomainCreate']

puts "Domain created: #{d['id']}\t#{d['domain']}"
