# Create a subscription
# Usage: ruby scripts/create_subscription.rb CUSTOMER_ID PRICE_ID

require_relative 'auth'

customer_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CUSTOMER_ID PRICE_ID")
price_id    = ARGV[1] or abort("Usage: ruby #{__FILE__} CUSTOMER_ID PRICE_ID")

body = {
  'customer' => customer_id,
  'items[0][price]' => price_id
}

data = stripe_request(:post, '/subscriptions', body: body)

puts "id:\t#{data['id']}"
puts "status:\t#{data['status'] || '-'}"
puts "current_period_start:\t#{data['current_period_start'] || '-'}"
puts "current_period_end:\t#{data['current_period_end'] || '-'}"
