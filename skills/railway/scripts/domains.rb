require_relative 'auth'

project_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID ENVIRONMENT_ID SERVICE_ID")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")
service_id     = ARGV[2] or abort("Missing SERVICE_ID")

query = <<~GQL
  query domains($projectId: String!, $environmentId: String!, $serviceId: String!) {
    domains(projectId: $projectId, environmentId: $environmentId, serviceId: $serviceId) {
      serviceDomains {
        id
        domain
        suffix
        targetPort
      }
      customDomains {
        id
        domain
        status {
          dnsRecords {
            hostlabel
            requiredValue
            currentValue
            status
          }
        }
      }
    }
  }
GQL

data = railway_query(query, {
  'projectId' => project_id,
  'environmentId' => environment_id,
  'serviceId' => service_id
})

domains = data['domains']

service_domains = domains['serviceDomains'] || []
unless service_domains.empty?
  puts "Service Domains:"
  service_domains.each do |d|
    puts "  #{d['id']}\t#{d['domain']}\tport:#{d['targetPort']}"
  end
end

custom_domains = domains['customDomains'] || []
unless custom_domains.empty?
  puts "Custom Domains:"
  custom_domains.each do |d|
    dns_status = (d.dig('status', 'dnsRecords') || []).map { |r| r['status'] }.join(', ')
    puts "  #{d['id']}\t#{d['domain']}\t#{dns_status}"
  end
end
