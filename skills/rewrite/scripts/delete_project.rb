# Delete a project
# Usage: ruby scripts/delete_project.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

rewrite_request(:delete, "/projects/#{project_id}")

puts "Deleted project: #{project_id}"
