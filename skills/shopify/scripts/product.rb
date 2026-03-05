# Get product details
# Usage: ruby scripts/product.rb PRODUCT_ID

require_relative 'auth'

product_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PRODUCT_ID")

data = shopify_request(:get, "/products/#{product_id}.json")
p = data['product']

body = (p['body_html'] || '')[0, 200]
variants_count = (p['variants'] || []).size

puts "ID:           #{p['id']}"
puts "Title:        #{p['title'] || '-'}"
puts "Body:         #{body}"
puts "Vendor:       #{p['vendor'] || '-'}"
puts "Product Type: #{p['product_type'] || '-'}"
puts "Status:       #{p['status'] || '-'}"
puts "Created:      #{p['created_at'] || '-'}"
puts "Variants:     #{variants_count}"
