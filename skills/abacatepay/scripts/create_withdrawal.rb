# Create a withdrawal to a PIX key
# Usage: ruby scripts/create_withdrawal.rb EXTERNAL_ID AMOUNT_CENTS PIX_TYPE PIX_KEY [--description DESC]
# PIX_TYPE: CPF, CNPJ, EMAIL, PHONE, EVP
# Example: ruby scripts/create_withdrawal.rb "withdraw-001" 5000 CPF "12345678900"

require_relative 'auth'

external_id = ARGV[0] or abort("Usage: ruby #{__FILE__} EXTERNAL_ID AMOUNT_CENTS PIX_TYPE PIX_KEY [--description DESC]")
amount      = ARGV[1] or abort("Missing AMOUNT_CENTS (minimum 350)")
pix_type    = ARGV[2] or abort("Missing PIX_TYPE (CPF, CNPJ, EMAIL, PHONE, EVP)")
pix_key     = ARGV[3] or abort("Missing PIX_KEY")

body = {
  'externalId' => external_id,
  'method' => 'PIX',
  'amount' => amount.to_i,
  'pix' => { 'type' => pix_type, 'key' => pix_key }
}

if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  body['description'] = ARGV[idx + 1]
end

data = abacate_request(:post, '/withdraw/create', body: body)

w = data['data']
puts "Created withdrawal: #{w['externalId'] || w['id']}"
