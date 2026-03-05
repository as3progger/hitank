# Create a product
# Usage: ruby scripts/create_product.rb TITLE [--body BODY] [--vendor VENDOR] [--product-type TYPE] [--status STATUS]

require_relative 'auth'

title = ARGV[0] or abort("Usage: ruby #{__FILE__} TITLE [--body BODY] [--vendor VENDOR] [--product-type TYPE] [--status STATUS]")

product = { 'title' => title }

if (idx = ARGV.index('--body')) && ARGV[idx + 1]
  product['body_html'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--vendor')) && ARGV[idx + 1]
  product['vendor'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--product-type')) && ARGV[idx + 1]
  product['product_type'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--status')) && ARGV[idx + 1]
  product['status'] = ARGV[idx + 1]
end

data = shopify_request(:post, '/products.json', body: { 'product' => product })
p = data['product']

puts "#{p['id']}\t#{p['title'] || '-'}\t#{p['status'] || '-'}"
