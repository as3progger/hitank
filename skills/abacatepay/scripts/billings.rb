# List all charges/billings
# Usage: ruby scripts/billings.rb

require_relative 'auth'

data = abacate_request(:get, '/billing/list')

(data['data'] || []).each do |b|
  status = b['status'] || '-'
  amount = b['amount'] ? "R$#{b['amount'].to_f / 100}" : '-'
  puts "#{b['id']}\t#{status}\t#{amount}\t#{b['url'] || '-'}"
end
