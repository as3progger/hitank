# List subscriptions
# Usage: ruby scripts/subscriptions.rb [--limit N] [--customer CUSTOMER_ID] [--status STATUS]

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

data = stripe_request(:get, '/subscriptions', params: params)

(data['data'] || []).each do |s|
  puts "#{s['id']}\t#{s['customer'] || '-'}\t#{s['status'] || '-'}\t#{s['current_period_end'] || '-'}"
end
