# List orders
# Usage: ruby scripts/orders.rb [--limit N] [--status STATUS] [--financial-status STATUS]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--status')) && ARGV[idx + 1]
  params['status'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--financial-status')) && ARGV[idx + 1]
  params['financial_status'] = ARGV[idx + 1]
end

data = shopify_request(:get, '/orders.json', params: params)

(data['orders'] || []).each do |o|
  puts "#{o['id']}\t#{o['name'] || '-'}\t#{o['email'] || '-'}\t#{o['financial_status'] || '-'}\t#{o['fulfillment_status'] || '-'}\t#{o['total_price'] || '-'}\t#{o['currency'] || '-'}"
end
