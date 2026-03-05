# Create a product
# Usage: ruby scripts/create_product.rb NAME [--description DESC]

require_relative 'auth'

name = ARGV[0] or abort("Usage: ruby #{__FILE__} NAME [--description DESC]")

body = { 'name' => name }
if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  body['description'] = ARGV[idx + 1]
end

data = stripe_request(:post, '/products', body: body)

puts "id:\t#{data['id']}"
puts "name:\t#{data['name'] || '-'}"
puts "active:\t#{data['active']}"
puts "created:\t#{data['created'] || '-'}"
