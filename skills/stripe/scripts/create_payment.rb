# Create a payment intent
# Usage: ruby scripts/create_payment.rb AMOUNT CURRENCY [--customer CUSTOMER_ID] [--description DESC]

require_relative 'auth'

amount   = ARGV[0] or abort("Usage: ruby #{__FILE__} AMOUNT CURRENCY [--customer CUSTOMER_ID] [--description DESC]")
currency = ARGV[1] or abort("Usage: ruby #{__FILE__} AMOUNT CURRENCY [--customer CUSTOMER_ID] [--description DESC]")

body = { 'amount' => amount, 'currency' => currency }
if (idx = ARGV.index('--customer')) && ARGV[idx + 1]
  body['customer'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  body['description'] = ARGV[idx + 1]
end

data = stripe_request(:post, '/payment_intents', body: body)

puts "id:\t#{data['id']}"
puts "amount:\t#{data['amount'] || 0}"
puts "currency:\t#{data['currency'] || '-'}"
puts "status:\t#{data['status'] || '-'}"
puts "client_secret:\t#{data['client_secret'] || '-'}"
