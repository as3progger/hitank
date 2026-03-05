# List invoices
# Usage: ruby scripts/invoices.rb [--limit N] [--customer CUSTOMER_ID] [--status STATUS]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--customer')) && ARGV[idx + 1]
  params['customer'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--status')) && ARGV[idx + 1]
  params['status'] = ARGV[idx + 1]
end

data = stripe_request(:get, '/invoices', params: params)

(data['data'] || []).each do |i|
  puts "#{i['id']}\t#{i['customer'] || '-'}\t#{i['status'] || '-'}\t#{i['amount_due'] || 0}\t#{i['currency'] || '-'}"
end
