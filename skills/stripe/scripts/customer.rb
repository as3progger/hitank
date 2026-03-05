# Get customer details
# Usage: ruby scripts/customer.rb CUSTOMER_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} CUSTOMER_ID")
data = stripe_request(:get, "/customers/#{id}")

puts "id:\t#{data['id']}"
puts "email:\t#{data['email'] || '-'}"
puts "name:\t#{data['name'] || '-'}"
puts "phone:\t#{data['phone'] || '-'}"
puts "created:\t#{data['created'] || '-'}"
puts "balance:\t#{data['balance'] || 0}"
puts "currency:\t#{data['currency'] || '-'}"
puts "delinquent:\t#{data['delinquent']}"
