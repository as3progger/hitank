# List companies
# Usage: ruby scripts/companies.rb [--limit N] [--after CURSOR]

require_relative 'auth'

params = { 'limit' => '10', 'properties' => 'name,domain,industry,phone,city,state' }

if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--after')) && ARGV[idx + 1]
  params['after'] = ARGV[idx + 1]
end

data = hubspot_request(:get, '/crm/v3/objects/companies', params: params)

(data['results'] || []).each do |c|
  p = c['properties'] || {}
  puts "#{c['id']}\t#{p['name'] || '-'}\t#{p['domain'] || '-'}\t#{p['industry'] || '-'}"
end

after = data.dig('paging', 'next', 'after')
puts "\nNext cursor: #{after}" if after
