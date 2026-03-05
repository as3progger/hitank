# Get issue details
# Usage: ruby scripts/issue.rb ISSUE_KEY

require_relative 'auth'

key = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY")

data = jira_request(:get, "/issue/#{key}")

fields   = data['fields']
status   = fields.dig('status', 'name') || '-'
assignee = fields.dig('assignee', 'displayName') || 'Unassigned'
reporter = fields.dig('reporter', 'displayName') || '-'
priority = fields.dig('priority', 'name') || '-'
type     = fields.dig('issuetype', 'name') || '-'
labels   = (fields['labels'] || []).join(', ')
labels   = '-' if labels.empty?
created  = fields['created'] || '-'
updated  = fields['updated'] || '-'

# Extract plain text from ADF description
desc = '-'
if fields['description']
  paragraphs = (fields['description']['content'] || []).flat_map do |block|
    (block['content'] || []).map { |c| c['text'] }.compact
  end
  desc = paragraphs.join(' ')[0..300]
end

puts "key:\t#{data['key']}"
puts "summary:\t#{fields['summary']}"
puts "type:\t#{type}"
puts "status:\t#{status}"
puts "priority:\t#{priority}"
puts "assignee:\t#{assignee}"
puts "reporter:\t#{reporter}"
puts "labels:\t#{labels}"
puts "created:\t#{created}"
puts "updated:\t#{updated}"
puts "description:\t#{desc}"
