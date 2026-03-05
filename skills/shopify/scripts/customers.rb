# List customers
# Usage: ruby scripts/customers.rb [--limit N]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end

data = shopify_request(:get, '/customers.json', params: params)

(data['customers'] || []).each do |c|
  puts "#{c['id']}\t#{c['email'] || '-'}\t#{c['first_name'] || '-'}\t#{c['last_name'] || '-'}\t#{c['orders_count'] || 0}\t#{c['total_spent'] || '0.00'}"
end
