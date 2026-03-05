# Create a message template
# Usage: ruby scripts/create_template.rb PROJECT_ID NAME CONTENT
# Example: ruby scripts/create_template.rb proj_123 "welcome" "Hello {{name}}, welcome!"

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID NAME CONTENT")
name       = ARGV[1] or abort("Missing NAME")
content    = ARGV[2] or abort("Missing CONTENT")

data = rewrite_request(:post, "/projects/#{project_id}/templates", body: {
  'name' => name,
  'content' => content
})

t = data['data'] || data
puts "Created template: #{t['id'] || t['name']}"
