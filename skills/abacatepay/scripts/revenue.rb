# Get revenue for a period
# Usage: ruby scripts/revenue.rb START_DATE END_DATE
# Dates in YYYY-MM-DD format
# Example: ruby scripts/revenue.rb 2026-01-01 2026-03-01

require_relative 'auth'

start_date = ARGV[0] or abort("Usage: ruby #{__FILE__} START_DATE END_DATE (YYYY-MM-DD)")
end_date   = ARGV[1] or abort("Missing END_DATE")

data = abacate_request(:get, '/public-mrr/revenue', params: {
  'startDate' => start_date,
  'endDate' => end_date
})

rev = data['data']
puts "total:\tR$#{rev['total'].to_f / 100}" if rev['total']
puts "transactions:\t#{rev['transactionCount'] || '-'}"
