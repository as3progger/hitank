# Update an issue
# Usage: ruby scripts/update_issue.rb ISSUE_KEY JSON_FIELDS
# Example: ruby scripts/update_issue.rb MYPROJ-123 '{"summary":"New title","priority":{"name":"High"}}'

require_relative 'auth'

key  = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY JSON_FIELDS")
json = ARGV[1] or abort("Missing JSON_FIELDS")

fields = JSON.parse(json)
jira_request(:put, "/issue/#{key}", body: { 'fields' => fields })

puts "Updated issue: #{key}"
