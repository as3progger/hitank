# Update an issue
# Usage: ruby scripts/update_issue.rb ISSUE_ID [--title TITLE] [--description DESC] [--priority N] [--state ID] [--assignee ID]

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID [--title TITLE] [--description DESC] [--priority N] [--state ID] [--assignee ID]")

input = {}
if (idx = ARGV.index('--title')) && ARGV[idx + 1]
  input['title'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  input['description'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--priority')) && ARGV[idx + 1]
  input['priority'] = ARGV[idx + 1].to_i
end
if (idx = ARGV.index('--state')) && ARGV[idx + 1]
  input['stateId'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--assignee')) && ARGV[idx + 1]
  input['assigneeId'] = ARGV[idx + 1]
end

if input.empty?
  abort "No updates specified. Use --title, --description, --priority, --state, or --assignee"
end

query = <<~GQL
  mutation($id: String!, $input: IssueUpdateInput!) {
    issueUpdate(id: $id, input: $input) {
      success
      issue { id identifier title state { name } assignee { name } priority }
    }
  }
GQL

data = linear_query(query, { 'id' => id, 'input' => input })
result = data['issueUpdate']

if result['success']
  i = result['issue']
  puts "Updated: #{i['identifier']} — #{i['title']}"
  puts "state:\t#{i.dig('state', 'name') || '-'}"
  puts "assignee:\t#{i.dig('assignee', 'name') || '-'}"
  puts "priority:\t#{i['priority'] || '-'}"
else
  puts "Failed to update issue"
end
