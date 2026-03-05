# Get invoice details
# Usage: ruby scripts/invoice.rb INVOICE_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} INVOICE_ID")
data = stripe_request(:get, "/invoices/#{id}")

puts "id:\t#{data['id']}"
puts "customer:\t#{data['customer'] || '-'}"
puts "status:\t#{data['status'] || '-'}"
puts "amount_due:\t#{data['amount_due'] || 0}"
puts "amount_paid:\t#{data['amount_paid'] || 0}"
puts "currency:\t#{data['currency'] || '-'}"
puts "created:\t#{data['created'] || '-'}"
puts "due_date:\t#{data['due_date'] || '-'}"
puts "hosted_invoice_url:\t#{data['hosted_invoice_url'] || '-'}"
