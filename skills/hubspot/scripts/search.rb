# Search CRM objects
# Usage: ruby scripts/search.rb OBJECT_TYPE QUERY [--limit N]
# OBJECT_TYPE: contacts, companies, deals, tickets
# Example: ruby scripts/search.rb contacts "john@example.com"

require_relative 'auth'

object_type = ARGV[0] or abort("Usage: ruby #{__FILE__} OBJECT_TYPE QUERY [--limit N]")
query       = ARGV[1] or abort("Missing QUERY")

limit = 10
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  limit = ARGV[idx + 1].to_i
end

body = { 'query' => query, 'limit' => limit }

data = hubspot_request(:post, "/crm/v3/objects/#{object_type}/search", body: body)

(data['results'] || []).each do |r|
  p = r['properties'] || {}
  label = p['firstname'] ? "#{p['firstname']} #{p['lastname']}" : (p['name'] || p['dealname'] || p['subject'] || r['id'])
  puts "#{r['id']}\t#{label}\t#{p['email'] || p['domain'] || p['dealstage'] || '-'}"
end

puts "\nTotal: #{data['total'] || 0}"
