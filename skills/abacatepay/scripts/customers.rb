# List all customers
# Usage: ruby scripts/customers.rb

require_relative 'auth'

data = abacate_request(:get, '/customer/list')

(data['data'] || []).each do |c|
  puts "#{c['id']}\t#{c['name'] || '-'}\t#{c['email'] || '-'}\t#{c['cellphone'] || '-'}\t#{c['taxId'] || '-'}"
end
