# List API keys for a project
# Usage: ruby scripts/api_keys.rb PROJECT_ID [--limit N] [--after CURSOR]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--limit N] [--after CURSOR]")

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--after')) && ARGV[idx + 1]
  params['after'] = ARGV[idx + 1]
end

data = rewrite_request(:get, "/projects/#{project_id}/api-keys", params: params)

(data['data'] || []).each do |k|
  puts "#{k['key'] || k['id']}\t#{k['name'] || '-'}\t#{k['createdAt'] || '-'}"
end
