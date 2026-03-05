# List deployments for a project
# Usage: ruby scripts/deploys.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = hb_request(:get, "/projects/#{project_id}/deploys")

deploys = data.is_a?(Array) ? data : data['results'] || []

deploys.each do |d|
  puts "#{d['revision'] || d['id']}\t#{d['environment']}\t#{d['local_username'] || d['user']}\t#{d['created_at']}"
end
