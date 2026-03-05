# List custom collections
# Usage: ruby scripts/collections.rb [--limit N]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end

data = shopify_request(:get, '/custom_collections.json', params: params)

(data['custom_collections'] || []).each do |c|
  puts "#{c['id']}\t#{c['title'] || '-'}\t#{c['handle'] || '-'}\t#{c['published_at'] || '-'}"
end
