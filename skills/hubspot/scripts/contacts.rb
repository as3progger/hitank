# List contacts
# Usage: ruby scripts/contacts.rb [--limit N] [--after CURSOR]

require_relative 'auth'

params = { 'limit' => '10', 'properties' => 'firstname,lastname,email,phone,company' }

if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--after')) && ARGV[idx + 1]
  params['after'] = ARGV[idx + 1]
end

data = hubspot_request(:get, '/crm/v3/objects/contacts', params: params)

(data['results'] || []).each do |c|
  p = c['properties'] || {}
  name = [p['firstname'], p['lastname']].compact.join(' ')
  name = '-' if name.empty?
  puts "#{c['id']}\t#{name}\t#{p['email'] || '-'}\t#{p['phone'] || '-'}\t#{p['company'] || '-'}"
end

after = data.dig('paging', 'next', 'after')
puts "\nNext cursor: #{after}" if after
