# Delete a template
# Usage: ruby scripts/delete_template.rb PROJECT_ID TEMPLATE_ID

require_relative 'auth'

project_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID TEMPLATE_ID")
template_id = ARGV[1] or abort("Missing TEMPLATE_ID")

rewrite_request(:delete, "/projects/#{project_id}/templates/#{template_id}")

puts "Deleted template: #{template_id}"
