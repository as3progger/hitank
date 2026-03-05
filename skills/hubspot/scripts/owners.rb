# List owners
# Usage: ruby scripts/owners.rb

require_relative 'auth'

data = hubspot_request(:get, '/crm/v3/owners')

(data['results'] || []).each do |o|
  name = "#{o['firstName']} #{o['lastName']}".strip
  puts "#{o['id']}\t#{name}\t#{o['email'] || '-'}"
end
