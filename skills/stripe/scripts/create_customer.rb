# Create a customer
# Usage: ruby scripts/create_customer.rb EMAIL [--name NAME] [--phone PHONE]

require_relative 'auth'

email = ARGV[0] or abort("Usage: ruby #{__FILE__} EMAIL [--name NAME] [--phone PHONE]")

body = { 'email' => email }
if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--phone')) && ARGV[idx + 1]
  body['phone'] = ARGV[idx + 1]
end

data = stripe_request(:post, '/customers', body: body)

puts "id:\t#{data['id']}"
puts "email:\t#{data['email'] || '-'}"
puts "name:\t#{data['name'] || '-'}"
