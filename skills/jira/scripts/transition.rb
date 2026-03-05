# Transition an issue (change status)
# Usage: ruby scripts/transition.rb ISSUE_KEY TRANSITION_ID

require_relative 'auth'

key           = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY TRANSITION_ID")
transition_id = ARGV[1] or abort("Missing TRANSITION_ID")

jira_request(:post, "/issue/#{key}/transitions", body: { 'transition' => { 'id' => transition_id } })

puts "Transitioned issue: #{key}"
