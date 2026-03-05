# List customers
# Usage: ruby scripts/customers.rb [--limit N] [--email EMAIL]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--email')) && ARGV[idx + 1]
  params['email'] = ARGV[idx + 1]
end

data = stripe_request(:get, '/customers', params: params)

(data['data'] || []).each do |c|
  puts "#{c['id']}\t#{c['email'] || '-'}\t#{c['name'] || '-'}\t#{c['created'] || '-'}"
end
