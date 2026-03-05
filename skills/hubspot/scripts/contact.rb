# Get contact details
# Usage: ruby scripts/contact.rb CONTACT_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} CONTACT_ID")

data = hubspot_request(:get, "/crm/v3/objects/contacts/#{id}", params: {
  'properties' => 'firstname,lastname,email,phone,company,jobtitle,lifecyclestage,hs_lead_status,createdate,lastmodifieddate'
})

p = data['properties'] || {}
puts "id:\t#{data['id']}"
puts "name:\t#{[p['firstname'], p['lastname']].compact.join(' ')}"
puts "email:\t#{p['email'] || '-'}"
puts "phone:\t#{p['phone'] || '-'}"
puts "company:\t#{p['company'] || '-'}"
puts "job_title:\t#{p['jobtitle'] || '-'}"
puts "lifecycle:\t#{p['lifecyclestage'] || '-'}"
puts "lead_status:\t#{p['hs_lead_status'] || '-'}"
puts "created:\t#{p['createdate'] || '-'}"
puts "updated:\t#{p['lastmodifieddate'] || '-'}"
