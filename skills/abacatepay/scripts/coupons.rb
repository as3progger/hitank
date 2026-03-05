# List all coupons
# Usage: ruby scripts/coupons.rb

require_relative 'auth'

data = abacate_request(:get, '/coupon/list')

(data['data'] || []).each do |c|
  kind = c['discountKind'] || '-'
  discount = c['discount'] || '-'
  label = kind == 'PERCENTAGE' ? "#{discount}%" : "R$#{discount.to_f / 100}"
  puts "#{c['id']}\t#{c['code'] || '-'}\t#{label}\t#{c['notes'] || '-'}"
end
