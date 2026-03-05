# List products
# Usage: ruby scripts/products.rb [--limit N] [--active true/false]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--active')) && ARGV[idx + 1]
  params['active'] = ARGV[idx + 1]
end

data = stripe_request(:get, '/products', params: params)

(data['data'] || []).each do |p|
  puts "#{p['id']}\t#{p['name'] || '-'}\t#{p['active']}\t#{p['created'] || '-'}"
end
