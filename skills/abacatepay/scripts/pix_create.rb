# Create a PIX QR code
# Usage: ruby scripts/pix_create.rb AMOUNT_CENTS [--description DESC] [--expires SECONDS]
# Example: ruby scripts/pix_create.rb 1000 --description "Pagamento teste"

require_relative 'auth'

amount = ARGV[0] or abort("Usage: ruby #{__FILE__} AMOUNT_CENTS [--description DESC] [--expires SECONDS]")

body = { 'amount' => amount.to_i }

if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  body['description'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--expires')) && ARGV[idx + 1]
  body['expiresIn'] = ARGV[idx + 1].to_i
end

data = abacate_request(:post, '/pixQrCode/create', body: body)

pix = data['data']
puts "id:\t#{pix['id']}"
puts "status:\t#{pix['status'] || '-'}"
puts "brCode:\t#{pix['brCode'] || '-'}"
puts "amount:\tR$#{pix['amount'].to_f / 100}" if pix['amount']
