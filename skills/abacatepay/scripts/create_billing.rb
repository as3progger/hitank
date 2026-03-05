# Create a charge/billing
# Usage: ruby scripts/create_billing.rb JSON_BODY
# Example: ruby scripts/create_billing.rb '{"frequency":"ONE_TIME","methods":["PIX"],"products":[{"externalId":"prod1","name":"Product","quantity":1,"price":1000}],"returnUrl":"https://example.com/cancel","completionUrl":"https://example.com/success"}'

require_relative 'auth'

json = ARGV[0] or abort("Usage: ruby #{__FILE__} JSON_BODY")

body = JSON.parse(json)
data = abacate_request(:post, '/billing/create', body: body)

billing = data['data']
puts "Created billing: #{billing['id']}"
puts "URL: #{billing['url']}" if billing['url']
