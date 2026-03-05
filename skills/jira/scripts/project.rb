# Get project details
# Usage: ruby scripts/project.rb PROJECT_KEY

require_relative 'auth'

key = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_KEY")

data = jira_request(:get, "/project/#{key}")

lead = data.dig('lead', 'displayName') || '-'
puts "key:\t#{data['key']}"
puts "name:\t#{data['name']}"
puts "type:\t#{data['projectTypeKey'] || '-'}"
puts "lead:\t#{lead}"
puts "url:\t#{data['self']}"
