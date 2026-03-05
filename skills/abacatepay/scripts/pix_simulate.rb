# Simulate a PIX payment (development mode only)
# Usage: ruby scripts/pix_simulate.rb PIX_ID

require_relative 'auth'

pix_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PIX_ID")

data = abacate_request(:post, '/pixQrCode/simulate-payment', params: { 'id' => pix_id })

pix = data['data']
puts "Simulated payment for PIX #{pix['id']}"
puts "status:\t#{pix['status'] || '-'}"
