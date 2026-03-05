# List all withdrawals
# Usage: ruby scripts/withdrawals.rb

require_relative 'auth'

data = abacate_request(:get, '/withdraw/list')

(data['data'] || []).each do |w|
  status = w['status'] || '-'
  amount = w['amount'] ? "R$#{w['amount'].to_f / 100}" : '-'
  puts "#{w['externalId'] || w['id']}\t#{status}\t#{amount}"
end
