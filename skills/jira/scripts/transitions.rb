# List available transitions for an issue
# Usage: ruby scripts/transitions.rb ISSUE_KEY

require_relative 'auth'

key = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY")

data = jira_request(:get, "/issue/#{key}/transitions")

(data['transitions'] || []).each do |t|
  to_status = t.dig('to', 'name') || '-'
  puts "#{t['id']}\t#{t['name']}\t-> #{to_status}"
end
