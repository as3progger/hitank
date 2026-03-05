# Create a customer
# Usage: ruby scripts/create_customer.rb EMAIL [--first-name NAME] [--last-name NAME] [--phone PHONE]

require_relative 'auth'

email = ARGV[0] or abort("Usage: ruby #{__FILE__} EMAIL [--first-name NAME] [--last-name NAME] [--phone PHONE]")

customer = { 'email' => email }

if (idx = ARGV.index('--first-name')) && ARGV[idx + 1]
  customer['first_name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--last-name')) && ARGV[idx + 1]
  customer['last_name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--phone')) && ARGV[idx + 1]
  customer['phone'] = ARGV[idx + 1]
end

data = shopify_request(:post, '/customers.json', body: { 'customer' => customer })
c = data['customer']

puts "#{c['id']}\t#{c['email'] || '-'}\t#{c['first_name'] || '-'}\t#{c['last_name'] || '-'}"
