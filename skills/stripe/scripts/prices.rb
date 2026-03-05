# List prices
# Usage: ruby scripts/prices.rb [--limit N] [--product PRODUCT_ID]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--product')) && ARGV[idx + 1]
  params['product'] = ARGV[idx + 1]
end

data = stripe_request(:get, '/prices', params: params)

(data['data'] || []).each do |p|
  recurring = p['recurring'] || {}
  puts "#{p['id']}\t#{p['product'] || '-'}\t#{p['unit_amount'] || 0}\t#{p['currency'] || '-'}\t#{p['type'] || '-'}\t#{recurring['interval'] || '-'}"
end
