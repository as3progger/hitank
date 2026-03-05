# List webhooks for a project
# Usage: ruby scripts/webhooks.rb PROJECT_ID [--limit N] [--after CURSOR]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--limit N] [--after CURSOR]")

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--after')) && ARGV[idx + 1]
  params['after'] = ARGV[idx + 1]
end

data = rewrite_request(:get, "/projects/#{project_id}/webhooks", params: params)

(data['data'] || []).each do |w|
  events = (w['events'] || []).join(', ')
  puts "#{w['id']}\t#{w['url'] || '-'}\t#{events}"
end
