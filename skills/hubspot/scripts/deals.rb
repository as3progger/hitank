# List deals
# Usage: ruby scripts/deals.rb [--limit N] [--after CURSOR]

require_relative 'auth'

params = { 'limit' => '10', 'properties' => 'dealname,dealstage,amount,closedate,pipeline,hubspot_owner_id' }

if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--after')) && ARGV[idx + 1]
  params['after'] = ARGV[idx + 1]
end

data = hubspot_request(:get, '/crm/v3/objects/deals', params: params)

(data['results'] || []).each do |d|
  p = d['properties'] || {}
  amount = p['amount'] ? "$#{p['amount']}" : '-'
  puts "#{d['id']}\t#{p['dealname'] || '-'}\t#{p['dealstage'] || '-'}\t#{amount}\t#{p['closedate'] || '-'}"
end

after = data.dig('paging', 'next', 'after')
puts "\nNext cursor: #{after}" if after
