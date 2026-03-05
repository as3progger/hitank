# List Jira boards (Agile)
# Usage: ruby scripts/boards.rb

require_relative 'auth'

data = jira_request(:get, '/board', agile: true)

(data['values'] || []).each do |b|
  type = b['type'] || '-'
  project = b.dig('location', 'projectKey') || '-'
  puts "#{b['id']}\t#{b['name']}\t#{type}\t#{project}"
end
