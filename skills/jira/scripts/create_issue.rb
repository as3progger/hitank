# Create an issue
# Usage: ruby scripts/create_issue.rb PROJECT_KEY SUMMARY [--type TYPE] [--priority PRIORITY] [--description DESC]
# Example: ruby scripts/create_issue.rb MYPROJ "Fix login bug" --type Bug --priority High

require_relative 'auth'

project_key = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_KEY SUMMARY [--type TYPE] [--priority PRIORITY] [--description DESC]")
summary     = ARGV[1] or abort("Missing SUMMARY")

issue_type = 'Task'
if (idx = ARGV.index('--type')) && ARGV[idx + 1]
  issue_type = ARGV[idx + 1]
end

body = {
  'fields' => {
    'project' => { 'key' => project_key },
    'summary' => summary,
    'issuetype' => { 'name' => issue_type }
  }
}

if (idx = ARGV.index('--priority')) && ARGV[idx + 1]
  body['fields']['priority'] = { 'name' => ARGV[idx + 1] }
end

if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  body['fields']['description'] = {
    'type' => 'doc',
    'version' => 1,
    'content' => [{ 'type' => 'paragraph', 'content' => [{ 'type' => 'text', 'text' => ARGV[idx + 1] }] }]
  }
end

data = jira_request(:post, '/issue', body: body)

puts "Created issue: #{data['key']}"
