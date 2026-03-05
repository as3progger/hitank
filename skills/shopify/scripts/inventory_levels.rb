# List inventory levels for a location
# Usage: ruby scripts/inventory_levels.rb LOCATION_ID [--limit N]

require_relative 'auth'

location_id = ARGV[0] or abort("Usage: ruby #{__FILE__} LOCATION_ID [--limit N]")

params = { 'location_ids' => location_id }
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end

data = shopify_request(:get, '/inventory_levels.json', params: params)

(data['inventory_levels'] || []).each do |il|
  puts "#{il['inventory_item_id']}\t#{il['location_id']}\t#{il['available'] || 0}"
end
