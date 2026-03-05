# Get subscription details
# Usage: ruby scripts/subscription.rb SUBSCRIPTION_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} SUBSCRIPTION_ID")
data = stripe_request(:get, "/subscriptions/#{id}")

puts "id:\t#{data['id']}"
puts "customer:\t#{data['customer'] || '-'}"
puts "status:\t#{data['status'] || '-'}"
puts "current_period_start:\t#{data['current_period_start'] || '-'}"
puts "current_period_end:\t#{data['current_period_end'] || '-'}"
puts "cancel_at_period_end:\t#{data['cancel_at_period_end']}"
puts "created:\t#{data['created'] || '-'}"
