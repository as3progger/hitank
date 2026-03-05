# Get company details
# Usage: ruby scripts/company.rb COMPANY_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} COMPANY_ID")

data = hubspot_request(:get, "/crm/v3/objects/companies/#{id}", params: {
  'properties' => 'name,domain,industry,phone,city,state,country,numberofemployees,annualrevenue,lifecyclestage,createdate,hs_lastmodifieddate'
})

p = data['properties'] || {}
puts "id:\t#{data['id']}"
puts "name:\t#{p['name'] || '-'}"
puts "domain:\t#{p['domain'] || '-'}"
puts "industry:\t#{p['industry'] || '-'}"
puts "phone:\t#{p['phone'] || '-'}"
puts "city:\t#{p['city'] || '-'}"
puts "state:\t#{p['state'] || '-'}"
puts "country:\t#{p['country'] || '-'}"
puts "employees:\t#{p['numberofemployees'] || '-'}"
puts "revenue:\t#{p['annualrevenue'] || '-'}"
puts "lifecycle:\t#{p['lifecyclestage'] || '-'}"
puts "created:\t#{p['createdate'] || '-'}"
