# List comments on an issue
# Usage: ruby scripts/comments.rb ISSUE_KEY

require_relative 'auth'

key = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY")

data = jira_request(:get, "/issue/#{key}/comment")

(data['comments'] || []).each do |c|
  author  = c.dig('author', 'displayName') || 'unknown'
  created = c['created'] || '-'
  # Extract plain text from ADF body
  text = (c.dig('body', 'content') || []).flat_map { |b| (b['content'] || []).map { |t| t['text'] }.compact }.join(' ')[0..100]
  puts "#{c['id']}\t#{author}\t#{created}\t#{text}"
end
