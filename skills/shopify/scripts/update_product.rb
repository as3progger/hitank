# Update a product
# Usage: ruby scripts/update_product.rb PRODUCT_ID [--title TITLE] [--body BODY] [--vendor VENDOR] [--status STATUS]

require_relative 'auth'

product_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PRODUCT_ID [--title TITLE] [--body BODY] [--vendor VENDOR] [--status STATUS]")

product = {}

if (idx = ARGV.index('--title')) && ARGV[idx + 1]
  product['title'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--body')) && ARGV[idx + 1]
  product['body_html'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--vendor')) && ARGV[idx + 1]
  product['vendor'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--status')) && ARGV[idx + 1]
  product['status'] = ARGV[idx + 1]
end

if product.empty?
  abort "Nothing to update. Use --title, --body, --vendor, or --status."
end

data = shopify_request(:put, "/products/#{product_id}.json", body: { 'product' => product })
p = data['product']

puts "#{p['id']}\t#{p['title'] || '-'}\t#{p['status'] || '-'}"
