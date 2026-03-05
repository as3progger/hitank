# Get store details and balance
# Usage: ruby scripts/store.rb

require_relative 'auth'

data = abacate_request(:get, '/store/get')

store = data['data']
puts "id:\t#{store['id'] || '-'}"
puts "name:\t#{store['name'] || '-'}"
puts "balance:\t#{store['balance'] || '-'}"
