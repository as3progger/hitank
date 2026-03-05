# Create a price
# Usage: ruby scripts/create_price.rb PRODUCT_ID UNIT_AMOUNT CURRENCY [--interval INTERVAL]

require_relative 'auth'

product_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} PRODUCT_ID UNIT_AMOUNT CURRENCY [--interval INTERVAL]")
unit_amount = ARGV[1] or abort("Usage: ruby #{__FILE__} PRODUCT_ID UNIT_AMOUNT CURRENCY [--interval INTERVAL]")
currency    = ARGV[2] or abort("Usage: ruby #{__FILE__} PRODUCT_ID UNIT_AMOUNT CURRENCY [--interval INTERVAL]")

body = {
  'product' => product_id,
  'unit_amount' => unit_amount,
  'currency' => currency
}
if (idx = ARGV.index('--interval')) && ARGV[idx + 1]
  body['recurring[interval]'] = ARGV[idx + 1]
end

data = stripe_request(:post, '/prices', body: body)

puts "id:\t#{data['id']}"
puts "product:\t#{data['product'] || '-'}"
puts "unit_amount:\t#{data['unit_amount'] || 0}"
puts "currency:\t#{data['currency'] || '-'}"
puts "type:\t#{data['type'] || '-'}"
