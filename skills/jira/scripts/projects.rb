# List Jira projects
# Usage: ruby scripts/projects.rb

require_relative 'auth'

data = jira_request(:get, '/project')

data.each do |p|
  type = p.dig('projectTypeKey') || '-'
  puts "#{p['key']}\t#{p['name']}\t#{type}"
end
