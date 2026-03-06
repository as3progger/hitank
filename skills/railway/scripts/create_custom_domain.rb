require_relative 'auth'

service_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} SERVICE_ID ENVIRONMENT_ID \"domain.com\" [--port PORT]")
environment_id = ARGV[1] or abort("Missing ENVIRONMENT_ID")
domain         = ARGV[2] or abort("Missing domain")

input = {
  'serviceId' => service_id,
  'environmentId' => environment_id,
  'domain' => domain
}

if (idx = ARGV.index('--port')) && ARGV[idx + 1]
  input['targetPort'] = ARGV[idx + 1].to_i
end

query = <<~GQL
  mutation customDomainCreate($input: CustomDomainCreateInput!) {
    customDomainCreate(input: $input) {
      id
      domain
      status {
        dnsRecords {
          hostlabel
          requiredValue
          status
        }
      }
    }
  }
GQL

data = railway_query(query, { 'input' => input })
d = data['customDomainCreate']

puts "Custom domain created: #{d['id']}\t#{d['domain']}"

dns = d.dig('status', 'dnsRecords') || []
unless dns.empty?
  puts "\nDNS Records to configure:"
  dns.each do |r|
    puts "  #{r['hostlabel']}\t#{r['requiredValue']}\t#{r['status']}"
  end
end
