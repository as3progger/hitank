# Get customer details
# Usage: ruby scripts/customer.rb CUSTOMER_ID

require_relative 'auth'

customer_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CUSTOMER_ID")

data = shopify_request(:get, "/customers/#{customer_id}.json")
c = data['customer']

puts "ID:           #{c['id']}"
puts "Email:        #{c['email'] || '-'}"
puts "First Name:   #{c['first_name'] || '-'}"
puts "Last Name:    #{c['last_name'] || '-'}"
puts "Phone:        #{c['phone'] || '-'}"
puts "Orders Count: #{c['orders_count'] || 0}"
puts "Total Spent:  #{c['total_spent'] || '0.00'}"
puts "Created:      #{c['created_at'] || '-'}"
