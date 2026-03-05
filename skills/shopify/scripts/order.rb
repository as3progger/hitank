# Get order details
# Usage: ruby scripts/order.rb ORDER_ID

require_relative 'auth'

order_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ORDER_ID")

data = shopify_request(:get, "/orders/#{order_id}.json")
o = data['order']

line_items_count = (o['line_items'] || []).size

puts "ID:                 #{o['id']}"
puts "Name:               #{o['name'] || '-'}"
puts "Email:              #{o['email'] || '-'}"
puts "Financial Status:   #{o['financial_status'] || '-'}"
puts "Fulfillment Status: #{o['fulfillment_status'] || '-'}"
puts "Total Price:        #{o['total_price'] || '-'} #{o['currency'] || '-'}"
puts "Created:            #{o['created_at'] || '-'}"
puts "Line Items:         #{line_items_count}"
