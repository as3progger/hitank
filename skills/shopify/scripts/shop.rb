# Get shop info
# Usage: ruby scripts/shop.rb

require_relative 'auth'

data = shopify_request(:get, '/shop.json')
s = data['shop']

puts "ID:       #{s['id']}"
puts "Name:     #{s['name'] || '-'}"
puts "Email:    #{s['email'] || '-'}"
puts "Domain:   #{s['domain'] || '-'}"
puts "Currency: #{s['currency'] || '-'}"
puts "Plan:     #{s['plan_name'] || '-'}"
puts "Country:  #{s['country'] || '-'}"
