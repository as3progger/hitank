# Get a template by ID
# Usage: ruby scripts/template.rb PROJECT_ID TEMPLATE_ID

require_relative 'auth'

project_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID TEMPLATE_ID")
template_id = ARGV[1] or abort("Missing TEMPLATE_ID")

data = rewrite_request(:get, "/projects/#{project_id}/templates/#{template_id}")

t = data['data'] || data
puts "id:\t#{t['id'] || '-'}"
puts "name:\t#{t['name'] || '-'}"
puts "content:\t#{t['content'] || '-'}"
puts "created:\t#{t['createdAt'] || '-'}"
