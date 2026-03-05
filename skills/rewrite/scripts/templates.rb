# List templates for a project
# Usage: ruby scripts/templates.rb PROJECT_ID [--limit N] [--after CURSOR]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--limit N] [--after CURSOR]")

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--after')) && ARGV[idx + 1]
  params['after'] = ARGV[idx + 1]
end

data = rewrite_request(:get, "/projects/#{project_id}/templates", params: params)

(data['data'] || []).each do |t|
  puts "#{t['id']}\t#{t['name'] || '-'}\t#{t['content'] || '-'}"
end

if data['pagination'] && data['pagination']['next']
  puts "\nnext_cursor:\t#{data['pagination']['next']}"
end
