require_relative 'auth'

domain_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN_ID --type service|custom")

domain_type = 'service'
if (idx = ARGV.index('--type')) && ARGV[idx + 1]
  domain_type = ARGV[idx + 1]
end

if domain_type == 'custom'
  query = <<~GQL
    mutation customDomainDelete($id: String!) {
      customDomainDelete(id: $id)
    }
  GQL
else
  query = <<~GQL
    mutation serviceDomainDelete($id: String!) {
      serviceDomainDelete(id: $id)
    }
  GQL
end

railway_query(query, { 'id' => domain_id })

puts "Domain deleted: #{domain_id}"
