# Get withdrawal details
# Usage: ruby scripts/withdrawal.rb EXTERNAL_ID

require_relative 'auth'

external_id = ARGV[0] or abort("Usage: ruby #{__FILE__} EXTERNAL_ID")

data = abacate_request(:get, '/withdraw/get', params: { 'externalId' => external_id })

w = data['data']
puts "id:\t#{w['id'] || '-'}"
puts "externalId:\t#{w['externalId'] || '-'}"
puts "status:\t#{w['status'] || '-'}"
puts "amount:\tR$#{w['amount'].to_f / 100}" if w['amount']
