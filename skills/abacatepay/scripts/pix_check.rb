# Check PIX QR code payment status
# Usage: ruby scripts/pix_check.rb PIX_ID

require_relative 'auth'

pix_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PIX_ID")

data = abacate_request(:get, '/pixQrCode/check', params: { 'id' => pix_id })

pix = data['data']
puts "id:\t#{pix['id']}"
puts "status:\t#{pix['status'] || '-'}"
puts "amount:\tR$#{pix['amount'].to_f / 100}" if pix['amount']
