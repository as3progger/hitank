# Get Monthly Recurring Revenue (MRR)
# Usage: ruby scripts/mrr.rb

require_relative 'auth'

data = abacate_request(:get, '/public-mrr/mrr')

mrr = data['data']
puts "mrr:\tR$#{mrr['mrr'].to_f / 100}" if mrr['mrr']
puts "active_subscriptions:\t#{mrr['totalActiveSubscriptions'] || '-'}"
