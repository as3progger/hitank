# Update a template
# Usage: ruby scripts/update_template.rb PROJECT_ID TEMPLATE_ID [--name NAME] [--content CONTENT]

require_relative 'auth'

project_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID TEMPLATE_ID [--name NAME] [--content CONTENT]")
template_id = ARGV[1] or abort("Missing TEMPLATE_ID")

body = {}
if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--content')) && ARGV[idx + 1]
  body['content'] = ARGV[idx + 1]
end

abort("Nothing to update. Use --name or --content") if body.empty?

data = rewrite_request(:patch, "/projects/#{project_id}/templates/#{template_id}", body: body)

t = data['data'] || data
puts "Updated template: #{t['id'] || template_id}"
