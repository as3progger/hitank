# List charges
# Usage: ruby scripts/charges.rb [--limit N] [--customer CUSTOMER_ID]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--customer')) && ARGV[idx + 1]
  params['customer'] = ARGV[idx + 1]
end

data = stripe_request(:get, '/charges', params: params)

(data['data'] || []).each do |c|
  puts "#{c['id']}\t#{c['amount'] || 0}\t#{c['currency'] || '-'}\t#{c['status'] || '-'}\t#{c['customer'] || '-'}"
end
