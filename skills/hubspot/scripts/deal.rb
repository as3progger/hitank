# Get deal details
# Usage: ruby scripts/deal.rb DEAL_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEAL_ID")

data = hubspot_request(:get, "/crm/v3/objects/deals/#{id}", params: {
  'properties' => 'dealname,dealstage,amount,closedate,pipeline,hubspot_owner_id,dealtype,createdate,hs_lastmodifieddate'
})

p = data['properties'] || {}
amount = p['amount'] ? "$#{p['amount']}" : '-'
puts "id:\t#{data['id']}"
puts "name:\t#{p['dealname'] || '-'}"
puts "stage:\t#{p['dealstage'] || '-'}"
puts "pipeline:\t#{p['pipeline'] || '-'}"
puts "amount:\t#{amount}"
puts "close_date:\t#{p['closedate'] || '-'}"
puts "type:\t#{p['dealtype'] || '-'}"
puts "owner:\t#{p['hubspot_owner_id'] || '-'}"
puts "created:\t#{p['createdate'] || '-'}"
