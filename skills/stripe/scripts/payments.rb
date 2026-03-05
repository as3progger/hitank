# List payment intents
# Usage: ruby scripts/payments.rb [--limit N] [--customer CUSTOMER_ID]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--customer')) && ARGV[idx + 1]
  params['customer'] = ARGV[idx + 1]
end

data = stripe_request(:get, '/payment_intents', params: params)

(data['data'] || []).each do |p|
  puts "#{p['id']}\t#{p['amount'] || 0}\t#{p['currency'] || '-'}\t#{p['status'] || '-'}\t#{p['customer'] || '-'}"
end
