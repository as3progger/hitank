# Update a project
# Usage: ruby scripts/update_project.rb PROJECT_ID [--name NAME]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--name NAME]")

body = {}
if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end

abort("Nothing to update. Use --name") if body.empty?

data = rewrite_request(:patch, "/projects/#{project_id}", body: body)

p_data = data['data'] || data
puts "Updated project: #{p_data['id'] || project_id}"
puts "name:\t#{p_data['name'] || '-'}"
