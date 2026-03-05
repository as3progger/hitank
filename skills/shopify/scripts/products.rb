# List products
# Usage: ruby scripts/products.rb [--limit N] [--status STATUS]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--status')) && ARGV[idx + 1]
  params['status'] = ARGV[idx + 1]
end

data = shopify_request(:get, '/products.json', params: params)

(data['products'] || []).each do |p|
  puts "#{p['id']}\t#{p['title'] || '-'}\t#{p['status'] || '-'}\t#{p['vendor'] || '-'}\t#{p['product_type'] || '-'}"
end
