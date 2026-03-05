# Create a deal
# Usage: ruby scripts/create_deal.rb DEAL_NAME [--stage STAGE] [--pipeline PIPELINE] [--amount AMOUNT] [--closedate DATE]

require_relative 'auth'

name = ARGV[0] or abort("Usage: ruby #{__FILE__} DEAL_NAME [--stage STAGE] [--pipeline PIPELINE] [--amount AMOUNT] [--closedate DATE]")

props = { 'dealname' => name }

{ 'stage' => 'dealstage', 'pipeline' => 'pipeline', 'amount' => 'amount', 'closedate' => 'closedate' }.each do |flag, prop|
  if (idx = ARGV.index("--#{flag}")) && ARGV[idx + 1]
    props[prop] = ARGV[idx + 1]
  end
end

data = hubspot_request(:post, '/crm/v3/objects/deals', body: { 'properties' => props })

puts "Created deal: #{data['id']}"
