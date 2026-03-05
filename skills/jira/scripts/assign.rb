# Assign an issue to a user
# Usage: ruby scripts/assign.rb ISSUE_KEY ACCOUNT_ID
# Use ACCOUNT_ID = "unassign" to remove assignee

require_relative 'auth'

key        = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY ACCOUNT_ID")
account_id = ARGV[1] or abort("Missing ACCOUNT_ID")

assignee = account_id == 'unassign' ? nil : account_id
jira_request(:put, "/issue/#{key}/assignee", body: { 'accountId' => assignee })

if assignee
  puts "Assigned issue #{key} to #{account_id}"
else
  puts "Unassigned issue #{key}"
end
