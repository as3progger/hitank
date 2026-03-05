# Create a coupon
# Usage: ruby scripts/create_coupon.rb CODE DISCOUNT KIND NOTES [--max-redeems N]
# KIND: PERCENTAGE or FIXED
# Example: ruby scripts/create_coupon.rb PROMO10 10 PERCENTAGE "10% off" --max-redeems 100

require_relative 'auth'

code     = ARGV[0] or abort("Usage: ruby #{__FILE__} CODE DISCOUNT KIND NOTES [--max-redeems N]")
discount = ARGV[1] or abort("Missing DISCOUNT")
kind     = ARGV[2] or abort("Missing KIND (PERCENTAGE or FIXED)")
notes    = ARGV[3] or abort("Missing NOTES")

body = {
  'code' => code,
  'discount' => discount.to_f,
  'discountKind' => kind,
  'notes' => notes
}

if (idx = ARGV.index('--max-redeems')) && ARGV[idx + 1]
  body['maxRedeems'] = ARGV[idx + 1].to_i
end

data = abacate_request(:post, '/coupon/create', body: body)

coupon = data['data']
puts "Created coupon: #{coupon['id']} — #{coupon['code']}"
