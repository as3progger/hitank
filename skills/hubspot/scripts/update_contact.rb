# Update a contact
# Usage: ruby scripts/update_contact.rb CONTACT_ID JSON_PROPERTIES
# Example: ruby scripts/update_contact.rb 123 '{"phone":"+5511999999999","company":"Acme"}'

require_relative 'auth'

id   = ARGV[0] or abort("Usage: ruby #{__FILE__} CONTACT_ID JSON_PROPERTIES")
json = ARGV[1] or abort("Missing JSON_PROPERTIES")

props = JSON.parse(json)
data = hubspot_request(:patch, "/crm/v3/objects/contacts/#{id}", body: { 'properties' => props })

puts "Updated contact: #{data['id']}"
