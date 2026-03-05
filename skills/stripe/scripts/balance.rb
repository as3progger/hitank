# Get account balance
# Usage: ruby scripts/balance.rb

require_relative 'auth'

data = stripe_request(:get, '/balance')

puts "Available:"
(data['available'] || []).each do |b|
  puts "  #{b['amount'] || 0}\t#{b['currency'] || '-'}"
end

puts "Pending:"
(data['pending'] || []).each do |b|
  puts "  #{b['amount'] || 0}\t#{b['currency'] || '-'}"
end
