# Create a customer
# Usage: ruby scripts/create_customer.rb NAME EMAIL CELLPHONE TAX_ID

require_relative 'auth'

name      = ARGV[0] or abort("Usage: ruby #{__FILE__} NAME EMAIL CELLPHONE TAX_ID")
email     = ARGV[1] or abort("Missing EMAIL")
cellphone = ARGV[2] or abort("Missing CELLPHONE")
tax_id    = ARGV[3] or abort("Missing TAX_ID (CPF or CNPJ)")

data = abacate_request(:post, '/customer/create', body: {
  'name' => name,
  'email' => email,
  'cellphone' => cellphone,
  'taxId' => tax_id
})

customer = data['data']
puts "Created customer: #{customer['id']} — #{customer['name']}"
