# Create an issue
# Usage: ruby scripts/create_issue.rb TEAM_ID TITLE [--description DESC] [--priority N] [--assignee ID] [--state ID] [--project ID]

require_relative 'auth'

team_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TEAM_ID TITLE [--description DESC] [--priority N] [--assignee ID]")
title   = ARGV[1] or abort("Missing TITLE")

input = { 'teamId' => team_id, 'title' => title }
if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  input['description'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--priority')) && ARGV[idx + 1]
  input['priority'] = ARGV[idx + 1].to_i
end
if (idx = ARGV.index('--assignee')) && ARGV[idx + 1]
  input['assigneeId'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--state')) && ARGV[idx + 1]
  input['stateId'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--project')) && ARGV[idx + 1]
  input['projectId'] = ARGV[idx + 1]
end

query = <<~GQL
  mutation($input: IssueCreateInput!) {
    issueCreate(input: $input) {
      success
      issue { id identifier title state { name } }
    }
  }
GQL

data = linear_query(query, { 'input' => input })
result = data['issueCreate']

if result['success']
  i = result['issue']
  puts "Created: #{i['identifier']} — #{i['title']}"
  puts "state:\t#{i.dig('state', 'name') || '-'}"
else
  puts "Failed to create issue"
end
