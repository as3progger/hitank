# Add a comment to an issue
# Usage: ruby scripts/add_comment.rb ISSUE_KEY COMMENT_TEXT

require_relative 'auth'

key  = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_KEY COMMENT_TEXT")
text = ARGV[1] or abort("Missing COMMENT_TEXT")

body = {
  'body' => {
    'type' => 'doc',
    'version' => 1,
    'content' => [{ 'type' => 'paragraph', 'content' => [{ 'type' => 'text', 'text' => text }] }]
  }
}

data = jira_request(:post, "/issue/#{key}/comment", body: body)

puts "Comment added: #{data['id']}"
